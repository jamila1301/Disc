//
//  FullPlayerViewController.swift
//  Disc
//
//  Created by Jamila Mahammadli on 18.10.25.
//

import UIKit
import SnapKit
import AVFoundation
import FirebaseAuth

final class FullPlayerViewController: UIViewController {
    
    private let albumImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 12
        v.clipsToBounds = true
        return v
    }()
    
    private let songTitleLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansSemiBold20
        v.textAlignment = .left
        v.textColor = .black
        v.numberOfLines = 2
        return v
    }()
    
    private let artistLabel: UILabel = {
        let v = UILabel()
        v.font = .plusJakartaSansRegular14
        v.textColor = .darkGray
        v.textAlignment = .left
        v.numberOfLines = 2
        return v
    }()
    
    private lazy var heartButton: UIButton = {
        let v = UIButton(type: .system)
        v.setImage(.heart, for: .normal)
        v.tintColor = .black
        v.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
        return v
    }()
    
    private let progressView: UIProgressView = {
        let v = UIProgressView(progressViewStyle: .default)
        v.progressTintColor = .black
        v.trackTintColor = .lightGray
        v.setProgress(0.0, animated: false)
        return v
    }()
    
    private let currentTimeLabel: UILabel = {
        let v = UILabel()
        v.text = "0:00"
        v.font = .plusJakartaSansMedium12
        v.textColor = .black
        return v
    }()
    
    private let remainingTimeLabel: UILabel = {
        let v = UILabel()
        v.text = "-0:00"
        v.font = .plusJakartaSansMedium12
        v.textColor = .black
        return v
    }()
    
    private lazy var previousImageView: UIImageView = {
        let v = UIImageView()
        v.image = .prev
        v.tintColor = .black
        let previousTap = UITapGestureRecognizer(target: self, action: #selector(didTapPrevious))
        v.addGestureRecognizer(previousTap)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private lazy var playPauseImageView: UIImageView = {
        let v = UIImageView()
        v.image = .play1
        v.tintColor = .black
        let playPauseTap = UITapGestureRecognizer(target: self, action: #selector(didTapPlayPause))
        v.addGestureRecognizer(playPauseTap)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private lazy var nextImageView: UIImageView = {
        let v = UIImageView()
        v.image = .next
        v.tintColor = .black
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(didTapNext))
        v.addGestureRecognizer(nextTap)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private var timeObserverToken: Any?
    private weak var observedPlayer: AVPlayer?
    private var isLiked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        removePeriodicTimeObserver()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [albumImageView, songTitleLabel, artistLabel, heartButton, progressView, currentTimeLabel, remainingTimeLabel, previousImageView, playPauseImageView, nextImageView].forEach { v in
            view.addSubview(v)
        }
        
        albumImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height * 0.03)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(albumImageView.snp.width)
        }
        
        songTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(UIScreen.main.bounds.height * 0.05)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(64)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(songTitleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(songTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(32)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.04)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(8)
            make.leading.equalTo(progressView.snp.leading)
        }
        
        remainingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(8)
            make.trailing.equalTo(progressView.snp.trailing)
        }
        
        playPauseImageView.snp.makeConstraints { make in
            make.top.equalTo(currentTimeLabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.05)
            make.centerX.equalToSuperview()
            make.size.equalTo(64)
        }
        
        previousImageView.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseImageView.snp.centerY)
            make.trailing.equalTo(playPauseImageView.snp.leading).offset(-44)
            make.size.equalTo(40)
        }
        
        nextImageView.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseImageView.snp.centerY)
            make.leading.equalTo(playPauseImageView.snp.trailing).offset(44)
            make.size.equalTo(40)
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .didStartPlaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayPauseIcon), name: .didUpdatePlayState, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetUI), name: .didStopPlaying, object: nil)
    }
    
    @objc private func updateUI(notification: Notification? = nil) {
        let manager = PlayerManager.shared
        
        if manager.isEpisodeMode {
            if let episode = manager.currentEpisode {
                songTitleLabel.text = episode.trackName
                artistLabel.text = episode.collectionName
                albumImageView.downloadImage(from: episode.artworkUrl600)
                checkIfEpisodeIsLiked(episode: episode)
            }
        } else {
            if let track = manager.currentTrack {
                songTitleLabel.text = track.trackName
                artistLabel.text = track.artistName
                albumImageView.downloadImage(from: track.artworkUrl100)
                checkIfTrackIsLiked(track: track)
            }
        }
        
        updatePlayPauseIcon()
        addPeriodicTimeObserver()
    }
    
    @objc private func resetUI() {
        songTitleLabel.text = nil
        artistLabel.text = nil
        albumImageView.image = nil
        progressView.progress = 0
        currentTimeLabel.text = "0:00"
        remainingTimeLabel.text = "-0:00"
        playPauseImageView.image = .play1
        heartButton.setImage(.heart, for: .normal)
        isLiked = false
        removePeriodicTimeObserver()
    }
    
    @objc private func updatePlayPauseIcon() {
        let icon = PlayerManager.shared.isPlaying ? UIImage.pause : UIImage.play1
        playPauseImageView.image = icon
    }
    
    @objc private func didTapPrevious() {
        PlayerManager.shared.previous()
    }
    
    @objc private func didTapPlayPause() {
        PlayerManager.shared.playPauseToggle()
    }
    
    @objc private func didTapNext() {
        PlayerManager.shared.next()
    }
    
    @objc private func didTapHeart() {
        let manager = PlayerManager.shared
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                if manager.isEpisodeMode, let episode = manager.currentEpisode {
                    if isLiked {
                        try await FirestoreManager.shared.removeLikedEpisode(userId: userId, episode: episode)
                        isLiked = false
                        heartButton.setImage(.heart, for: .normal)
                    } else {
                        try await FirestoreManager.shared.saveLikedEpisode(userId: userId, episode: episode)
                        isLiked = true
                        heartButton.setImage(.heartFill, for: .normal)
                    }
                } else if let track = manager.currentTrack {
                    if isLiked {
                        try await FirestoreManager.shared.removeLikedMusic(userId: userId, track: track)
                        isLiked = false
                        heartButton.setImage(.heart, for: .normal)
                    } else {
                        try await FirestoreManager.shared.saveLikedMusic(userId: userId, track: track)
                        isLiked = true
                        heartButton.setImage(.heartFill, for: .normal)
                    }
                }
                NotificationCenter.default.post(name: .didUpdateLikedItems, object: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func checkIfTrackIsLiked(track: Track) {
        guard let userId = Auth.auth().currentUser?.uid else {
            isLiked = false
            heartButton.setImage(.heart, for: .normal)
            return
        }
        
        Task {
            do {
                let likedTracks = try await FirestoreManager.shared.fetchLikedMusics(userId: userId)
                isLiked = likedTracks.contains { $0.musicName == track.trackName && $0.artistName == track.artistName }
                heartButton.setImage(isLiked ? .heartFill : .heart, for: .normal)
            } catch {
                print(error.localizedDescription)
                isLiked = false
                heartButton.setImage(.heart, for: .normal)
            }
        }
    }
    
    private func checkIfEpisodeIsLiked(episode: Episode) {
        guard let userId = Auth.auth().currentUser?.uid else {
            isLiked = false
            heartButton.setImage(.heart, for: .normal)
            return
        }
        
        Task {
            do {
                let likedEpisodes = try await FirestoreManager.shared.fetchLikedEpisodes(userId: userId)
                isLiked = likedEpisodes.contains { $0.episodeName == episode.trackName }
                heartButton.setImage(isLiked ? .heartFill : .heart, for: .normal)
            } catch {
                print(error.localizedDescription)
                isLiked = false
                heartButton.setImage(.heart, for: .normal)
            }
        }
    }
    
    private func addPeriodicTimeObserver() {
        guard let player = PlayerManager.shared.player else { return }
        removePeriodicTimeObserver()
        observedPlayer = player
        
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self, let duration = player.currentItem?.duration.seconds, duration.isFinite else { return }
            
            let progress = time.seconds / duration
            self.progressView.progress = Float(progress)
            self.currentTimeLabel.text = self.formatTime(time.seconds)
            self.remainingTimeLabel.text = "-\(self.formatTime(duration - time.seconds))"
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let token = timeObserverToken, let observed = observedPlayer {
            observed.removeTimeObserver(token)
        }
        timeObserverToken = nil
        observedPlayer = nil
    }
    
    private func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        let totalSeconds = Int(round(time))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
