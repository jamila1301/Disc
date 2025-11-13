//
//  CategoryTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 16.10.25.
//

import UIKit
import SnapKit

nonisolated enum CategoryCollectionSection {
    case main
}

typealias CategoryCollectionDataSource = UICollectionViewDiffableDataSource<CategoryCollectionSection, CategoryCollectionViewCell.Item>
typealias CategoryCollectionSnapshot = NSDiffableDataSourceSnapshot<CategoryCollectionSection, CategoryCollectionViewCell.Item>

final class CategoryTableViewCell: UITableViewCell {
        
    private var nameList: [CategoryCollectionViewCell.Item] = []
    private var colorNames: [String] = []
    private var dataSource: CategoryCollectionDataSource?
    
    var onCategorySelected: ((String) -> ())?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 2 - 34, height: 88)
        layout.minimumLineSpacing = 17
        layout.minimumInteritemSpacing = 17
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .screenBackground
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.delegate = self
        v.dataSource = dataSource
        v.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
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
            make.height.equalTo(760)
        }
    }
    
    @MainActor
    private func color(name: String) -> UIColor {
        UIColor(named: name) ?? .clear
    }
    
    private func createDiffableDataSource() {
        dataSource = CategoryCollectionDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(item: item)
            cell.setBackgroundColor(color: self.color(name: self.colorNames[indexPath.row]))
            return cell
        }
    }
    
    private func applySnapshot(items: [CategoryCollectionViewCell.Item]) {
        var snapshot = CategoryCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension CategoryTableViewCell {
    nonisolated struct Item: Hashable {
        let nameList: [CategoryCollectionViewCell.Item]
        let colorNames: [String]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(nameList)
            hasher.combine(colorNames)
        }
    }
    
    func configure(item: Item) {
        self.nameList = item.nameList
        self.colorNames = item.colorNames
        applySnapshot(items: item.nameList)
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = nameList[indexPath.row].categoryName
        onCategorySelected?(category)
    }
}
