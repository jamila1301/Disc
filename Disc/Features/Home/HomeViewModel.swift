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
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            Task { await self?.fetchData() }
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
                    trackId: track.trackId,
                    leftImage: track.artworkUrl100,
                    topLabel: "home_music_label".localized(),
                    nameLabel: track.trackName,
                    artistLabel: track.artistName,
                    timeLabel: duration,
                    previewUrl: track.previewUrl
                ))
            }
            
            let musicTracks = try await ITunesService.shared.fetchMusic(term: "music", limit: 5)
            let musicItems: [HomeMusicCollectionViewCell.Item] = musicTracks.map { track in
                    .init(
                        trackId: track.trackId,
                        image: track.artworkUrl100,
                        musicName: track.trackName,
                        artistName: track.artistName,
                        previewUrl: track.previewUrl
                    )
            }
            
            let podcastTracks = try await ITunesService.shared.fetchPodcast(term: "podcast", limit: 5)
            let podcastItems: [HomePodcastCollectionViewCell.Item] = podcastTracks.map { podcast in
                    .init(
                        image: podcast.artworkUrl100,
                        musicName: podcast.collectionName,
                        artistName: podcast.artistName,
                        previewUrl: nil,
                        collectionId: podcast.collectionId
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
    
    func playBannerTrack(item: HomeBannerCollectionViewCell.Item) async {
        guard let musicTracks = try? await ITunesService.shared.fetchMusic(term: "music", limit: 199) else { return }
        
        let track = Track(
            trackId: item.trackId,
            trackName: item.nameLabel,
            artistName: item.artistLabel,
            artworkUrl100: item.leftImage,
            trackTimeMillis: nil,
            previewUrl: item.previewUrl
        )
        
        let tracks: [Track] = musicTracks.compactMap {
            return Track(
                trackId: item.trackId,
                trackName: $0.trackName,
                artistName: $0.artistName,
                artworkUrl100: $0.artworkUrl100,
                trackTimeMillis: nil,
                previewUrl: $0.previewUrl
            )
        }
        
        PlayerManager.shared.playBannerTrack(track, trackList: tracks)
    }
    
    func playHomeMusic(item: HomeMusicCollectionViewCell.Item) async {
        guard let musicTracks = try? await ITunesService.shared.fetchMusic(term: "music", limit: 199) else { return }
        
        let track = Track(
            trackId: item.trackId,
            trackName: item.musicName,
            artistName: item.artistName,
            artworkUrl100: item.image,
            trackTimeMillis: nil,
            previewUrl: item.previewUrl
        )
        
        let tracks: [Track] = musicTracks.compactMap {
            return Track(
                trackId: item.trackId,
                trackName: $0.trackName,
                artistName: $0.artistName,
                artworkUrl100: $0.artworkUrl100,
                trackTimeMillis: nil,
                previewUrl: $0.previewUrl
            )
        }
        
        PlayerManager.shared.playHomeMusic(track, trackList: tracks)
    }

}
