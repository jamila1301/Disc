//
//  EpisodeViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import Foundation

protocol EpisodeViewModelDelegate: AnyObject {
    func reloadTableView()
}

@MainActor
final class EpisodeViewModel {
    private var router: EpisodeRouterProtocol
    weak var delegate: EpisodeViewModelDelegate? = nil
    private(set) var items: [EpisodeTableViewCell.Item] = []
    private let collectionId: Int
    
    init(collectionId: Int, router: EpisodeRouterProtocol) {
        self.collectionId = collectionId
        self.router = router
        Task {
            await fetchData()
        }
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            Task { await self?.fetchData() }
        }
    }
    
    func fetchData() async {
        do {
            let episodeTracks = try await ITunesService.shared.fetchEpisode(for: collectionId)
            self.items = episodeTracks.map { episode in
                EpisodeTableViewCell.Item(
                    trackId: episode.trackId,
                    image: episode.artworkUrl600,
                    episodeName: episode.trackName,
                    collectionName: episode.collectionName,
                    timeLabel: "\(episode.trackTimeMillis?.formattedDuration ?? "")  " + "home_episodes_mins".localized(),
                    previewUrl: episode.previewUrl
                )
            }
            self.delegate?.reloadTableView()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didTapEpisode(item: EpisodeTableViewCell.Item) {
        let episode = Episode(
            trackId: item.trackId,
            trackName: item.episodeName,
            artistName: item.collectionName,
            episodeUrl: nil,
            artworkUrl600: item.image,
            trackTimeMillis: nil,
            previewUrl: item.previewUrl,
            description: nil,
            collectionName: item.collectionName
        )
        
        let episodes: [Episode] = items.map { item in
            Episode(
                trackId: item.trackId,
                trackName: item.episodeName,
                artistName: item.collectionName,
                episodeUrl: nil,
                artworkUrl600: item.image,
                trackTimeMillis: nil,
                previewUrl: item.previewUrl,
                description: nil,
                collectionName: item.collectionName
            )
        }
        
        PlayerManager.shared.playEpisode(episode, episodeList: episodes)
    }
}
