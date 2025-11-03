//
//  LikedEpisodeTableViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 22.10.25.
//

import UIKit
import SnapKit

final class LikedEpisodeTableViewCell: UITableViewCell {
    
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
        v.numberOfLines = 1
        return v
    }()
    
    private let artistNameLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium12
        v.textColor = .lightGrayPrimary
        v.numberOfLines = 1
        return v
    }()
    
    private let labelsStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 6
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
        
        [episodeNameLabel, artistNameLabel].forEach { v in
            labelsStackView.addArrangedSubview(v)
        }
        
        [topImageView, labelsStackView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        topImageView.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}

extension LikedEpisodeTableViewCell {
    nonisolated struct Item: Hashable {
        let image: String
        let episodeName: String
        let artistName: String
        let previewUrl: String?
        let collectionName: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(episodeName)
            hasher.combine(artistName)
            hasher.combine(collectionName)
        }
    }
    
    func configure(item: Item) {
        self.topImageView.downloadImage(from: item.image)
        self.episodeNameLabel.text = item.episodeName
        self.artistNameLabel.text = item.artistName
    }
}
