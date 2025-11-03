//
//  FavoriteTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit

nonisolated enum FavoriteCollectionSection {
    case main
}

typealias FavoriteCollectionDataSource = UICollectionViewDiffableDataSource<FavoriteCollectionSection, FavoriteCollectionViewCell.Item>
typealias FavoriteCollectionSnapshot = NSDiffableDataSourceSnapshot<FavoriteCollectionSection, FavoriteCollectionViewCell.Item>

protocol FavoriteTableViewCellDelegate: AnyObject {
    func didSelectFavoriteItem(item: FavoriteCollectionViewCell.Item)
}

final class FavoriteTableViewCell: UITableViewCell {
    
    weak var delegate: FavoriteTableViewCellDelegate?
    
    private var likedList: [FavoriteCollectionViewCell.Item] = []
    private var dataSource: FavoriteCollectionDataSource?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 2 - 32, height: 205)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.isScrollEnabled = false
        v.delegate = self
        v.dataSource = dataSource
        v.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
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
            make.height.equalTo(500)
        }
    }
    
    private func createDiffableDataSource() {
        dataSource = FavoriteCollectionDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(item: item)
            return cell
        }
    }
    
    private func applySnapshot(items: [FavoriteCollectionViewCell.Item]) {
        var snapshot = FavoriteCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension FavoriteTableViewCell {
    nonisolated struct Item: Hashable {
        let likedList: [FavoriteCollectionViewCell.Item]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(likedList)
        }
    }
    
    func configure(item: Item) {
        self.likedList = item.likedList
        applySnapshot(items: item.likedList)
    }
}

extension FavoriteTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = likedList[indexPath.row]
        delegate?.didSelectFavoriteItem(item: selectedItem)
    }
}
