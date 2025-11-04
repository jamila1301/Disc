//
//  AccountDetailTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 26.10.25.
//

import UIKit
import SnapKit
import FirebaseAuth

final class AccountDetailTableViewCell: UITableViewCell {
    
    private let profileImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 30
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    private let nameLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansSemibold24
        v.textAlignment = .left
        v.numberOfLines = .zero
        return v
    }()
    
    private let emailLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansRegular14
        v.textColor = .lightGrayPrimary
        v.textAlignment = .left
        v.numberOfLines = .zero
        return v
    }()
    
    private let labelsStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 0
        v.distribution = .fillEqually
        return v
    }()
    
    private let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 16
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
        [nameLabel, emailLabel].forEach { v in
            labelsStackView.addArrangedSubview(v)
        }
        
        [profileImageView, labelsStackView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }
}

extension AccountDetailTableViewCell {
    nonisolated struct Item: Hashable {
        let image: String?
        let name: String
        let email: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(email)
        }
    }
    
    func configure(item: Item) {
        if let photoURL = item.image {
            self.profileImageView.downloadImage(from: photoURL)
        } else {
            self.profileImageView.image = .avatar
        }
        nameLabel.text = item.name
        emailLabel.text = item.email
    }
}
