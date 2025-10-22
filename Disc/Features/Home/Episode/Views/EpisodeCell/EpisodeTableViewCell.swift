//
//  EpisodeTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit
import SnapKit

final class EpisodeTableViewCell: UITableViewCell {
    
    private let topImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        return v
    }()
    
    private let episodeNameLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansSemiBold14
        v.numberOfLines = .zero
        return v
    }()
    
    private let collectionNameLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium12
        v.textColor = .lightGrayPrimary
        v.numberOfLines = .zero
        return v
    }()
    
    private let timeLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium12
        v.textColor = .lightGrayPrimary
        v.numberOfLines = .zero
        return v
    }()
    
    private let topStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 10
        return v
    }()
    
    private let bottomStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 3
        return v
    }()
    
    private let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 16
        v.alignment = .center
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
        
        [collectionNameLabel, timeLabel].forEach { v in
            bottomStackView.addArrangedSubview(v)
        }
        
        [episodeNameLabel, bottomStackView].forEach { v in
            topStackView.addArrangedSubview(v)
        }
        
        [topImageView, topStackView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        topImageView.snp.makeConstraints { make in
            make.size.equalTo(110)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}

extension EpisodeTableViewCell {
    struct Item {
        let image: String
        let episodeName: String
        let collectionName: String
        let timeLabel: String
        let previewUrl: String?
    }
    
    func configure(item: Item) {
        self.topImageView.downloadImage(from: item.image)
        self.episodeNameLabel.text = item.episodeName
        self.collectionNameLabel.text = item.collectionName
        self.timeLabel.text = item.timeLabel
    }
}
