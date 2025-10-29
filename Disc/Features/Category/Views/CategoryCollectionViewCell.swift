//
//  CategoryCollectionViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 16.10.25.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let categoryLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = .plusJakartaSansBold20
        v.textAlignment = .center
        v.numberOfLines = .zero
        return v
    }()
    
    private let mainView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .screenBackground
        contentView.addSubview(mainView)
        mainView.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}

extension CategoryCollectionViewCell {
    struct Item {
        let categoryName: String
    }
    
    func configure(item: Item) {
        self.categoryLabel.text = item.categoryName
    }
    
    func setBackgroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
}
