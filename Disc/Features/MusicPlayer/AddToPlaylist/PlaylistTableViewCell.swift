//
//  PlaylistCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 20.10.25.
//

import UIKit
import SnapKit

final class PlaylistTableViewCell: UITableViewCell {
    private let albumImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium16
        v.textAlignment = .left
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
        contentView.backgroundColor = .white
        
        [albumImageView, titleLabel].forEach { v in
            contentView.addSubview(v)
        }
        
        albumImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
            make.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
}

extension PlaylistTableViewCell {
    struct Item {
        let image: UIImage
        let title: String
    }
    
    func configure(item: Item) {
        self.albumImageView.image = item.image
        self.titleLabel.text = item.title
    }
}
