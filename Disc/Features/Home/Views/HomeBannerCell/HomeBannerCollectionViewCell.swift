//
//  HomeBannerCollectionViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit
import SnapKit

final class HomeBannerCollectionViewCell: UICollectionViewCell {
        
    private let leftImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    private let topLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium10
        v.textColor = UIColor.white.withAlphaComponent(0.6)
        v.numberOfLines = .zero
        return v
    }()
    
    private let nameLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansSemiBold18
        v.textColor = .white
        v.numberOfLines = .zero
        return v
    }()
    
    private let artistNameLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium12
        v.textColor = UIColor.white.withAlphaComponent(0.7)
        v.numberOfLines = .zero
        return v
    }()
    
    private let dotImageView: UIImageView = {
        let v = UIImageView()
        v.image = .dot
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let timeLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium12
        v.textColor = UIColor.white.withAlphaComponent(0.7)
        v.numberOfLines = .zero
        return v
    }()
    
    private let playImageView: UIImageView = {
        let v = UIImageView()
        v.image = .play
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let playView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    private let bannerImageView: UIImageView = {
        let v = UIImageView()
        v.image = .banner
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        return v
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .defaultBlue
        v.layer.cornerRadius = 20
        v.layer.masksToBounds = true
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
        contentView.addSubview(containerView)
        playView.addSubview(playImageView)
        [bannerImageView, leftImageView, topLabel, nameLabel, artistNameLabel, dotImageView, timeLabel, playView].forEach { v in
            containerView.addSubview(v)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bannerImageView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.width.equalTo(130)
            make.trailing.bottom.equalToSuperview()
        }
        
        leftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(112)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(leftImageView.snp.top)
            make.leading.equalTo(leftImageView.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualTo(playView.snp.leading).offset(-8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(12)
            make.leading.equalTo(topLabel)
            make.trailing.lessThanOrEqualTo(playView.snp.leading).offset(-8)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(topLabel)
        }
        
        dotImageView.snp.makeConstraints { make in
            make.centerY.equalTo(artistNameLabel)
            make.leading.equalTo(artistNameLabel.snp.trailing).offset(6)
            make.size.equalTo(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dotImageView)
            make.leading.equalTo(dotImageView.snp.trailing).offset(6)
        }
        
        playView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        playImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(12)
        }
    }
}

extension HomeBannerCollectionViewCell {
    struct Item {
        let leftImage: String
        let topLabel: String
        let nameLabel: String
        let artistLabel: String
        let timeLabel: String
        let previewUrl: String?
    }
    
    func configure(item: Item) {
        self.leftImageView.downloadImage(from: item.leftImage)
        self.topLabel.text = item.topLabel
        self.nameLabel.text = item.nameLabel
        self.artistNameLabel.text = item.artistLabel
        self.timeLabel.text = item.timeLabel
    }
}
