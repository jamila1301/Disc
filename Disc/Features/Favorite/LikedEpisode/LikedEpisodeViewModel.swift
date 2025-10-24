//
//  LikedEpisodeViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import Foundation
import FirebaseAuth

protocol LikedEpisodeViewModelDelegate: AnyObject {
    func reloadTableView()
}

@MainActor
final class LikedEpisodeViewModel {
    private let router: LikedEpisodeRouterProtocol
    weak var delegate: LikedEpisodeViewModelDelegate?
    
    private(set) var likedEpisodeList: [LikedEpisodeTableViewCell.Item] = []
    
    init(router: LikedEpisodeRouterProtocol) {
        self.router = router
        setupNotifications()
        Task {
            await fetchLikedEpisodes()
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLikedEpisodes), name: .didUpdateLikedItems, object: nil)
    }
    
    @objc private func refreshLikedEpisodes() {
        Task {
            await fetchLikedEpisodes()
        }
    }
    
    func fetchLikedEpisodes() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            likedEpisodeList = try await FirestoreManager.shared.fetchLikedEpisodes(userId: userId)
            delegate?.reloadTableView()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didSelectEpisode(index: Int) {
        guard index < likedEpisodeList.count else { return }
        
        let episodeList: [Episode] = likedEpisodeList.compactMap {
            return Episode(
                trackId: nil,
                trackName: $0.episodeName,
                artistName: nil,
                episodeUrl: nil,
                artworkUrl600: $0.image,
                trackTimeMillis: nil,
                previewUrl: $0.previewUrl,
                description: nil,
                collectionName: $0.collectionName
            )
        }
        
        let selectedEpisode = episodeList[index]
        
        PlayerManager.shared.playEpisode(selectedEpisode, episodeList: episodeList)
    }
}
