//
//  SettingsTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 26.10.25.
//

import UIKit
import SnapKit

nonisolated enum SettingsItemType: Hashable {
    case account
    case language
    case about
    case termsAndConditions
}

final class SettingsTableViewCell: UITableViewCell {
    
    private let leftImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansSemiBold16
        v.numberOfLines = .zero
        return v
    }()
    
    private let rightImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 16
        v.alignment = .center
        return v
    }()
    
    private let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lightGrayTextfield.cgColor
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
        
        contentView.addSubview(mainStackView)
        
        mainView.addSubview(leftImageView)
        
        [mainView, titleLabel, rightImageView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        mainView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
}

extension SettingsTableViewCell {
    nonisolated struct Item: Hashable {
        let type: SettingsItemType
        let leftImage: UIImage
        let title: String
        let rightImage: UIImage
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(type)
            hasher.combine(title)
        }
    }
    
    func configure(item:Item) {
        self.leftImageView.image = item.leftImage
        self.titleLabel.text = item.title
        self.rightImageView.image = item.rightImage
    }
}
