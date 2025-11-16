//
//  HomeMusicTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import UIKit
import SnapKit

nonisolated enum HomeMusicCollectionSection {
    case main
}

typealias HomeMusicCollectionDataSource = UICollectionViewDiffableDataSource<HomeMusicCollectionSection, HomeMusicCollectionViewCell.Item>
typealias HomeMusicCollectionSnapshot = NSDiffableDataSourceSnapshot<HomeMusicCollectionSection, HomeMusicCollectionViewCell.Item>

final class HomeMusicTableViewCell: UITableViewCell {
    
    var onSelectMusic: ((HomeMusicCollectionViewCell.Item) -> Void)?
    
    var buttonAction: (() -> Void)?
    
    private var musicList: [HomeMusicCollectionViewCell.Item] = []
    private var dataSource: HomeMusicCollectionDataSource?
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.text = "home_recommended_music_title".localized()
        v.font = .plusJakartaSansSemiBold18
        v.numberOfLines = .zero
        v.textAlignment = .left
        v.textColor = .black
        return v
    }()
    
    private lazy var showButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("home_show_more_button".localized(), for: .normal)
        v.setTitleColor(UIColor.defaultBlue, for: .normal)
        v.titleLabel?.font = .plusJakartaSansSemiBold12
        v.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
        return v
    }()
    
    private let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 8
        v.alignment = .center
        v.distribution = .equalSpacing
        return v
    }()
        
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 120, height: 173)
        layout.minimumLineSpacing = 16
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = dataSource
        v.register(HomeMusicCollectionViewCell.self, forCellWithReuseIdentifier: HomeMusicCollectionViewCell.identifier)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createDiffableDataSource()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .screenBackground
        [mainStackView, collectionView].forEach { v in
            contentView.addSubview(v)
        }
        
        [topLabel, showButton].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.horizontalEdges.equalToSuperview()
        }
        
        showButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(173)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    @objc private func didTapShowMore() {
        buttonAction?()
    }
    
    private func createDiffableDataSource() {
        dataSource = HomeMusicCollectionDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMusicCollectionViewCell.identifier, for: indexPath) as? HomeMusicCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(item: item)
            return cell
        }
    }
    
    private func applySnapshot(items: [HomeMusicCollectionViewCell.Item]) {
        var snapshot = HomeMusicCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension HomeMusicTableViewCell {
    nonisolated struct Item: Hashable {
        let musicList: [HomeMusicCollectionViewCell.Item]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(musicList)
        }
    }
    
    func configure(item: Item) {
        self.musicList = item.musicList
        topLabel.text = "home_recommended_music_title".localized()
        showButton.setTitle("home_show_more_button".localized(), for: .normal)
        applySnapshot(items: item.musicList)
    }
}

extension HomeMusicTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = musicList[indexPath.item]
        onSelectMusic?(selected)
    }
}

extension HomeMusicTableViewCell: LocalizeUpdateable {
    func didChangeLanguage() {
        topLabel.text = "home_recommended_music_title".localized()
        showButton.setTitle("home_show_more_button".localized(), for: .normal)
    }
}
