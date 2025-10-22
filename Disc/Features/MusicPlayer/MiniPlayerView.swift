//
//  MiniPlayerView.swift
//  Disc
//
//  Created by Jamila Mahammadli on 18.10.25.
//

import UIKit
import SnapKit

final class MiniPlayerView: UIView {
    
    var onTapMiniPlayer: (() -> Void)? = nil
        
    private let imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansSemiBold14
        v.textColor = .white
        v.numberOfLines = 1
        return v
    }()
    
    private let artistLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansMedium12
        v.textColor = .lightGrayTextfield
        v.numberOfLines = 1
        return v
    }()
    
    private lazy var playPauseButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(.play1, for: .normal)
        v.tintColor = .white
        v.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        return v
    }()
    
    private lazy var nextButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(.next, for: .normal)
        v.tintColor = .white
        v.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return v
    }()
    
    private lazy var previousButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(.prev, for: .normal)
        v.tintColor = .white
        v.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        return v
    }()
    
    private let buttonStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 8
        v.distribution = .equalSpacing
        v.alignment = .center
        return v
    }()
    
    private let labelStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 4
        return v
    }()
    
    private let mainStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 12
        v.alignment = .center
        return v
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupObservers()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMiniPlayer))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupUI() {
        backgroundColor = .defaultBlue
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        addSubview(mainStackView)
        
        [previousButton, playPauseButton, nextButton].forEach { v in
            buttonStackView.addArrangedSubview(v)
        }
        
        [titleLabel, artistLabel].forEach { v in
            labelStackView.addArrangedSubview(v)
        }
        
        [imageView, labelStackView, buttonStackView].forEach { v in
            mainStackView.addArrangedSubview(v)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .didStartPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayPauseIcon), name: .didUpdatePlayState, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetUI), name: .didStopPlaying, object: nil)
    }
        
    @objc private func updateUI(_ notification: Notification) {
        let manager = PlayerManager.shared
        
        if manager.isEpisodeMode {
            if let episode = notification.object as? Episode {
                titleLabel.text = episode.trackName
                artistLabel.text = episode.collectionName
                imageView.downloadImage(from: episode.artworkUrl600)
                
            }
        } else {
            if let track = notification.object as? Track {
                titleLabel.text = track.trackName
                artistLabel.text = track.artistName
                imageView.downloadImage(from: track.artworkUrl100)
            }
        }
        playPauseButton.setImage(manager.isPlaying ? .pause : .play1, for: .normal)
    }

    
    @objc private func updatePlayPauseIcon() {
        let icon = PlayerManager.shared.isPlaying ? UIImage.pause : UIImage.play1
        playPauseButton.setImage(icon, for: .normal)
    }
    
    @objc private func resetUI() {
        titleLabel.text = nil
        artistLabel.text = nil
        imageView.image = nil
        playPauseButton.setImage(.play1, for: .normal)
    }
        
    @objc private func didTapMiniPlayer() {
        onTapMiniPlayer?()
    }
    
    @objc private func didTapPlayPause() {
        PlayerManager.shared.playPauseToggle()
    }
    
    @objc private func didTapNext() {
        PlayerManager.shared.next()
    }
    
    @objc private func didTapPrevious() {
        PlayerManager.shared.previous()
    }
}
