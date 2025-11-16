//
//  PlayerManager.swift
//  Disc
//
//  Created by Jamila Mahammadli on 18.10.25.
//

import UIKit
import AVFoundation

final class PlayerManager {
    
    var player: AVPlayer?
    var isRepeatEnabled = false
    var isShuffleEnabled = false
    
    private(set) var trackList: [Track] = []
    private(set) var currentTrackIndex: Int = 0
    
    private(set) var episodeList: [Episode] = []
    private(set) var currentEpisodeIndex: Int = 0
    
    var isEpisodeMode = false
    
    var isPlaying: Bool {
        return player?.rate != 0
    }
    
    var currentTrack: Track? {
        guard trackList.indices.contains(currentTrackIndex) else { return nil }
        return trackList[currentTrackIndex]
    }
    
    var currentEpisode: Episode? {
        guard episodeList.indices.contains(currentEpisodeIndex) else { return nil }
        return episodeList[currentEpisodeIndex]
    }
    
    func playBannerTrack(_ track: Track, trackList: [Track]) {
        isEpisodeMode = false
        self.trackList = [track] + trackList.filter { $0.trackName != track.trackName }
        currentTrackIndex = 0
        playCurrentTrack()
    }
    
    func playHomeMusic(_ track: Track, trackList: [Track]) {
        isEpisodeMode = false
        self.trackList = trackList
        currentTrackIndex = trackList.firstIndex(where: { $0.trackName == track.trackName }) ?? 0
        playTrack(track)
    }
    
    func playEpisode(_ episode: Episode, episodeList: [Episode]) {
        isEpisodeMode = true
        self.episodeList = episodeList
        currentEpisodeIndex = episodeList.firstIndex(where: { $0.trackName == episode.trackName }) ?? 0
        playEpisodeItem(episode)
    }
    
    private func setupPlayerWithURL(_ url: URL) {
        if let old = player {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: old.currentItem)
        }
        player = AVPlayer(url: url)
        if let item = player?.currentItem {
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: item)
        }
    }
    
    private func playEpisodeItem(_ episode: Episode) {
        guard let urlString = episode.previewUrl, let url = URL(string: urlString) else { return }
        setupPlayerWithURL(url)
        player?.play()
        
        NotificationCenter.default.post(name: .didStartPlaying, object: episode)
        NotificationCenter.default.post(name: .didUpdatePlayState, object: nil)
    }
    
    private func playCurrentEpisode() {
        guard let episode = currentEpisode else { return }
        playEpisodeItem(episode)
    }
    
    private func playTrack(_ track: Track) {
        guard let urlString = track.previewUrl, let url = URL(string: urlString) else { return }
        setupPlayerWithURL(url)
        player?.play()
        
        NotificationCenter.default.post(name: .didStartPlaying, object: track)
        NotificationCenter.default.post(name: .didUpdatePlayState, object: nil)
    }
    
    private func playCurrentTrack() {
        guard let track = currentTrack else { return }
        playTrack(track)
    }
    
    func playPauseToggle() {
        guard let player = player else { return }
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
        NotificationCenter.default.post(name: .didUpdatePlayState, object: nil)
    }
    
    func next() {
        if isEpisodeMode {
            guard !episodeList.isEmpty else { return }
            if isShuffleEnabled {
                playRandomEpisode()
            } else {
                currentEpisodeIndex = (currentEpisodeIndex + 1) % episodeList.count
                playCurrentEpisode()
            }
        } else {
            guard !trackList.isEmpty else { return }
            if isShuffleEnabled {
                playRandomTrack()
            } else {
                currentTrackIndex = (currentTrackIndex + 1) % trackList.count
                playCurrentTrack()
            }
        }
    }
    
    func previous() {
        if isEpisodeMode {
            guard !episodeList.isEmpty else { return }
            currentEpisodeIndex = (currentEpisodeIndex - 1 + episodeList.count) % episodeList.count
            playCurrentEpisode()
        } else {
            guard !trackList.isEmpty else { return }
            currentTrackIndex = (currentTrackIndex - 1 + trackList.count) % trackList.count
            playCurrentTrack()
        }
    }
    
    func stop() {
        player?.pause()
        if let item = player?.currentItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: item)
        }
        player = nil
        trackList.removeAll()
        episodeList.removeAll()
        currentTrackIndex = 0
        currentEpisodeIndex = 0
        NotificationCenter.default.post(name: .didStopPlaying, object: nil)
    }
    
    private func playRandomTrack() {
        guard !trackList.isEmpty else { return }
        currentTrackIndex = Int.random(in: 0..<trackList.count)
        playCurrentTrack()
    }
    
    private func playRandomEpisode() {
        guard !episodeList.isEmpty else { return }
        currentEpisodeIndex = Int.random(in: 0..<episodeList.count)
        playCurrentEpisode()
    }
    
    @objc private func playerItemDidFinish(_ notification: Notification) {
        if isRepeatEnabled {
            player?.seek(to: .zero)
            player?.play()
            NotificationCenter.default.post(name: .didUpdatePlayState, object: nil)
        } else {
            next()
        }
    }
}

extension Notification.Name {
    static let didStartPlaying = Notification.Name("didStartPlaying")
    static let didStopPlaying = Notification.Name("didStopPlaying")
    static let didUpdatePlayState = Notification.Name("didUpdatePlayState")
    static let didUpdateLikedItems = Notification.Name("didUpdateLikedItems")
}
