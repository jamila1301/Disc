//
//  LikedMusicViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import Foundation
import FirebaseAuth

protocol LikedMusicViewModelDelegate: AnyObject {
    func reloadTableView()
}

@MainActor
final class LikedMusicViewModel {
    private let router: LikedMusicRouterProtocol
    weak var delegate: LikedMusicViewModelDelegate?
    
    private(set) var likedMusicList: [LikedMusicTableViewCell.Item] = []
    
    init(router: LikedMusicRouterProtocol) {
        self.router = router
        setupNotifications()
        Task {
            await fetchLikedMusics()
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLikedMusics), name: .didUpdateLikedItems, object: nil)
    }
    
    @objc private func refreshLikedMusics() {
        Task {
            await fetchLikedMusics()
        }
    }
    
    func fetchLikedMusics() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            likedMusicList = try await FirestoreManager.shared.fetchLikedMusics(userId: userId)
            delegate?.reloadTableView()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didSelectMusic(index: Int) {
        guard index < likedMusicList.count else { return }
        
        let trackList: [Track] = likedMusicList.compactMap {
            return Track(
                trackId: nil,
                trackName: $0.musicName,
                artistName: $0.artistName,
                artworkUrl100: $0.image,
                trackTimeMillis: nil,
                previewUrl: $0.previewUrl
            )
        }
        
        let selectedTrack = trackList[index]
        
        PlayerManager.shared.playHomeMusic(selectedTrack, trackList: trackList)
    }
}
