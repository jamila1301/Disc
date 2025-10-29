//
//  FavoriteCollectionViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit

final class FavoriteCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansSemiBold14
        v.numberOfLines = .zero
        return v
    }()
    
    private let mainView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 8
        v.backgroundColor = .white
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(mainView)
        
        [imageView, titleLabel].forEach { v in
            mainView.addSubview(v)
        }
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(12)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
}

extension FavoriteCollectionViewCell {
    struct Item {
        let image: UIImage
        let title: String
    }
    
    func configure(item: Item) {
        self.imageView.image = item.image
        self.titleLabel.text = item.title
    }
}
