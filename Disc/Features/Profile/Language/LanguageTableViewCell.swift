//
//  LanguageTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 27.10.25.
//

import UIKit
import SnapKit

final class LanguageTableViewCell: UITableViewCell {
    private let languageImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    private let languageLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium16
        v.textAlignment = .left
        v.textColor = .white
        v.numberOfLines = .zero
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
        contentView.backgroundColor = .defaultBlue
        
        [languageImageView, languageLabel].forEach { v in
            contentView.addSubview(v)
        }
        
        languageImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
            make.bottom.equalToSuperview().inset(10)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.leading.equalTo(languageImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
}

extension LanguageTableViewCell {
    struct Item {
        let image: UIImage
        let title: String
    }
    
    func configure(item: Item) {
        self.languageImageView.image = item.image
        self.languageLabel.text = item.title
    }
}
