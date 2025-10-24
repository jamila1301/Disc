//
//  FavoriteTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit

protocol FavoriteTableViewCellDelegate: AnyObject {
    func didSelectFavoriteItem(item: FavoriteCollectionViewCell.Item)
}

final class FavoriteTableViewCell: UITableViewCell {
    
    weak var delegate: FavoriteTableViewCellDelegate?
    
    private var likedList: [FavoriteCollectionViewCell.Item] = []
    
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
        v.dataSource = self
        v.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
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
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(500)
        }
    }
}

extension FavoriteTableViewCell {
    struct Item {
        let likedList: [FavoriteCollectionViewCell.Item]
    }
    
    func configure(item: Item) {
        self.likedList = item.likedList
        self.collectionView.reloadData()
    }
}

extension FavoriteTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell {
            cell.configure(item: likedList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = likedList[indexPath.row]
        delegate?.didSelectFavoriteItem(item: selectedItem)
    }

}
