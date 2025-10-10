//
//  HomeViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadTableView()
}

enum HomeCellType {
    case banner(HomeBannerTableViewCell.Item)
    case music(HomeMusicTableViewCell.Item)
    case podcast(HomePodcastTableViewCell.Item)
}

@MainActor
final class HomeViewModel {
    private var router: HomeRouterProtocol
    weak var delegate: HomeViewModelDelegate? = nil
    private(set) var cellTypes: [HomeCellType] = []
    
    init(router: HomeRouterProtocol) {
        self.router = router
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            async let trackResult = ITunesService.shared.fetchMusic(term: "Too Good at Goodbyes", limit: 1)
            async let trackResult2 = ITunesService.shared.fetchMusic(term: "Sia", limit: 1)
            let (tracks1, tracks2) = try await (trackResult, trackResult2)
            let allTracks = tracks1 + tracks2
            
            var bannerItems: [HomeBannerCollectionViewCell.Item] = []
            for track in allTracks {
                let duration = track.trackTimeMillis?.formattedDuration ?? "--:--"
                bannerItems.append(.init(
                    leftImage: track.artworkUrl100,
                    topLabel: "Music",
                    nameLabel: track.trackName,
                    artistLabel: track.artistName,
                    timeLabel: duration
                ))
            }
            
            let musicTracks = try await ITunesService.shared.fetchMusic(term: "music", limit: 5)
            let musicItems: [HomeMusicCollectionViewCell.Item] = musicTracks.map { track in
                    .init(
                        image: track.artworkUrl100,
                        musicName: track.trackName,
                        artistName: track.artistName
                    )
            }
            
            let podcastTracks = try await ITunesService.shared.fetchPodcast(term: "podcast", limit: 5)
            let podcastItems: [HomeMusicCollectionViewCell.Item] = podcastTracks.map { podcast in
                    .init(
                        image: podcast.artworkUrl100,
                        musicName: podcast.collectionName,
                        artistName: podcast.artistName
                    )
            }
            
            self.cellTypes = [
                .banner(.init(bannerList: bannerItems)),
                .music(.init(musicList: musicItems)),
                .podcast(.init(musicList: podcastItems))
            ]
            self.delegate?.reloadTableView()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didTapMusic() {
        router.navigateToMusic()
    }
    
    func didTapPodcast() {
        router.navigateToPodcast()
    }
    
    func didTapEpisode(collectionId: Int) {
        router.navigateToEpisode(collectionId: collectionId)
    }
}

