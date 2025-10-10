//
//  PodcastViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import Foundation

protocol PodcastViewModelDelegate: AnyObject {
    func reloadTableView()
}

enum PodcastCellType {
    case podcast(PodcastTableViewCell.Item)
}

@MainActor
final class PodcastViewModel {
    private var router: PodcastRouterProtocol
    weak var delegate: PodcastViewModelDelegate? = nil
    private(set) var cellTypes: [PodcastCellType] = []
    
    init(router: PodcastRouterProtocol) {
        self.router = router
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            let podcastTracks = try await ITunesService.shared.fetchPodcast(term: "podcast", limit: 200)
            self.cellTypes = podcastTracks.map { podcast in
                    .podcast(.init(
                        image: podcast.artworkUrl100,
                        podcastName: podcast.collectionName,
                        artistName: podcast.artistName,
                        collectionId: podcast.collectionId
                    ))
            }
            self.delegate?.reloadTableView()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didSelectPodcast(collectionId: Int) {
        router.navigateToEpisode(collectionId: collectionId)
    }
}

