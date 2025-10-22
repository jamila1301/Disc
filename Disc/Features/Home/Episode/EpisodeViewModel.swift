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

enum EpisodeCellType {
    case episode(EpisodeTableViewCell.Item)
}

@MainActor
final class EpisodeViewModel {
    private var router: EpisodeRouterProtocol
    weak var delegate: EpisodeViewModelDelegate? = nil
    private(set) var cellTypes: [EpisodeCellType] = []
    private let collectionId: Int
    
    init(collectionId: Int, router: EpisodeRouterProtocol) {
        self.collectionId = collectionId
        self.router = router
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            let episodeTracks = try await ITunesService.shared.fetchEpisode(for: collectionId)
            self.cellTypes = episodeTracks.map { episode in
                .episode(.init(
                    image: episode.artworkUrl600,
                    episodeName: episode.trackName,
                    collectionName: episode.collectionName,
                    timeLabel: "\(episode.trackTimeMillis?.formattedDuration ?? "")  mins",
                    previewUrl: episode.previewUrl
                ))
            }
            self.delegate?.reloadTableView()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didTapEpisode(item: EpisodeTableViewCell.Item) {
        let episode = Episode(
            trackId: nil,
            trackName: item.episodeName,
            artistName: item.collectionName,
            episodeUrl: nil,
            artworkUrl600: item.image,
            trackTimeMillis: nil,
            previewUrl: item.previewUrl,
            description: nil,
            collectionName: item.collectionName
        )
        
        let episodes: [Episode] = cellTypes.compactMap {
            if case .episode(let item) = $0 {
                return Episode(
                    trackId: nil,
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
            return nil
        }
        
        PlayerManager.shared.playEpisode(episode, episodeList: episodes)
    }
}
