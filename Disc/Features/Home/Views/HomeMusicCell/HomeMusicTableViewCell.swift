//
//  HomeMusicTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import UIKit
import SnapKit

final class HomeMusicTableViewCell: UITableViewCell {
    
    var onSelectMusic: ((HomeMusicCollectionViewCell.Item) -> Void)?
    
    var buttonAction: (() -> Void)?
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.text = "Recommended Music"
        v.font = .plusJakartaSansSemiBold18
        v.numberOfLines = .zero
        v.textAlignment = .left
        return v
    }()
    
    private lazy var showButton: UIButton = {
        let v = UIButton(type: .system)
        v.setTitle("Show more", for: .normal)
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
        return v
    }()
    
    private var musicList: [HomeMusicCollectionViewCell.Item] = []
    
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
        v.dataSource = self
        v.register(HomeMusicCollectionViewCell.self, forCellWithReuseIdentifier: HomeMusicCollectionViewCell.identifier)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
}

extension HomeMusicTableViewCell {
    struct Item {
        let musicList: [HomeMusicCollectionViewCell.Item]
    }
    
    func configure(item: Item) {
        self.musicList = item.musicList
        self.collectionView.reloadData()
    }
}

extension HomeMusicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMusicCollectionViewCell.identifier, for: indexPath) as? HomeMusicCollectionViewCell {
            cell.configure(item: musicList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = musicList[indexPath.item]
        onSelectMusic?(selected)
    }

}
