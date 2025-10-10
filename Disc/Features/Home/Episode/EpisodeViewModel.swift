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
            self.cellTypes = episodeTracks.compactMap { episode in
                guard let trackName = episode.trackName ,
                      let artworkUrl = episode.artworkUrl600 else {
                    return nil
                }
                return .episode(.init(
                    image: artworkUrl,
                    episodeName: trackName,
                    collectionName: episode.collectionName,
                    timeLabel: "\(episode.trackTimeMillis?.formattedDuration ?? "")  mins"
                ))
            }
            self.delegate?.reloadTableView()
        } catch {
            print(error.localizedDescription)
        }
    }
}
