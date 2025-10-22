//
//  HomePodcastCollectionViewCell.swift
//  Disc
//
//  Created by Jamila Mahammadli on 20.10.25.
//

import UIKit
import SnapKit

final class HomePodcastCollectionViewCell: UICollectionViewCell {
    
    private let topImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        return v
    }()
    
    private let musicNameLabel: UILabel = {
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
        v.axis = .vertical
        v.spacing = 12
        v.alignment = .leading
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
        contentView.addSubview(mainStackView)
        
        [musicNameLabel, artistNameLabel].forEach { v in
            labelsStackView.addArrangedSubview(v)
        }
        
        [topImageView, labelsStackView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        topImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HomePodcastCollectionViewCell {
    struct Item {
        let image: String
        let musicName: String
        let artistName: String
        let previewUrl: String?
        let collectionId: Int?
    }
    
    func configure(item: Item) {
        self.topImageView.downloadImage(from: item.image)
        self.musicNameLabel.text = item.musicName
        self.artistNameLabel.text = item.artistName
    }
}
