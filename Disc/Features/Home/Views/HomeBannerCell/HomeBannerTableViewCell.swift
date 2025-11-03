//
//  HomeBannerTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit

nonisolated enum HomeBannerCollectionSection {
    case main
}

typealias HomeBannerCollectionDataSource = UICollectionViewDiffableDataSource<HomeBannerCollectionSection, HomeBannerCollectionViewCell.Item>
typealias HomeBannerCollectionSnapshot = NSDiffableDataSourceSnapshot<HomeBannerCollectionSection, HomeBannerCollectionViewCell.Item>

final class HomeBannerTableViewCell: UITableViewCell {
    
    var onSelectBanner: ((HomeBannerCollectionViewCell.Item) -> Void)?
    
    private var bannerList: [HomeBannerCollectionViewCell.Item] = []
    private var dataSource: HomeBannerCollectionDataSource?
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: UIScreen.main.bounds.width - 50, height: 144)
        layout.minimumLineSpacing = 18
        
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = dataSource
        v.register(HomeBannerCollectionViewCell.self, forCellWithReuseIdentifier: HomeBannerCollectionViewCell.identifier)
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
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(144)
        }
    }
    
    private func createDiffableDataSource() {
        dataSource = HomeBannerCollectionDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCollectionViewCell.identifier, for: indexPath) as? HomeBannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(item: item)
            return cell
        }
    }
    
    private func applySnapshot(items: [HomeBannerCollectionViewCell.Item]) {
        var snapshot = HomeBannerCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension HomeBannerTableViewCell {
    nonisolated struct Item: Hashable {
        let bannerList: [HomeBannerCollectionViewCell.Item]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(bannerList)
        }
    }
    
    func configure(item: Item) {
        self.bannerList = item.bannerList
        applySnapshot(items: item.bannerList)
    }
}

extension HomeBannerTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = bannerList[indexPath.item]
        onSelectBanner?(selected)
    }
}
