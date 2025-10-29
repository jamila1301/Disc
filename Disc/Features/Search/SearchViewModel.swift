//
//  SearchViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 15.10.25.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func reloadTableView()
    func showNoData()
    func showInitialState()
    func showLoading()
}

@MainActor
final class SearchViewModel {
    
    enum Section: Int, CaseIterable {
        case music
        case podcast
        
        var title: String {
            switch self {
            case .music: return "search_music_title".localized()
            case .podcast: return "search_podcast_title".localized()
            }
        }
    }
    
    private var router: SearchRouterProtocol
    weak var delegate: SearchViewModelDelegate? = nil
    
    private(set) var musicItems: [MusicTableViewCell.Item] = []
    private(set) var podcastItems: [PodcastTableViewCell.Item] = []
    
    init(router: SearchRouterProtocol) {
        self.router = router
    }
    
    func search(text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            musicItems = []
            podcastItems = []
            delegate?.showNoData()
            return
        }
        
        delegate?.showLoading()
        
        do {
            async let musicResults = ITunesService.shared.fetchMusic(term: trimmed, limit: 200)
            async let podcastResults = ITunesService.shared.fetchPodcast(term: trimmed, limit: 200)
            
            let (musicTracks, podcastTracks) = try await (musicResults, podcastResults)
            
            self.musicItems = musicTracks.map { track in
                    .init(
                        trackId: track.trackId,
                        image: track.artworkUrl100,
                        musicName: track.trackName,
                        artistName: track.artistName,
                        previewUrl: track.previewUrl
                    )
            }
            
            self.podcastItems = podcastTracks.map { podcast in
                    .init(
                        image: podcast.artworkUrl100,
                        podcastName: podcast.collectionName,
                        artistName: podcast.artistName,
                        collectionId: podcast.collectionId
                    )
            }
            
            if musicItems.isEmpty && podcastItems.isEmpty {
                delegate?.showNoData()
            } else {
                delegate?.reloadTableView()
            }
            
        } catch {
            self.musicItems = []
            self.podcastItems = []
            delegate?.showNoData()
        }
    }
    
    func didTapEpisode(collectionId: Int) {
        router.navigateToEpisode(collectionId: collectionId)
    }
    
    func didTapMusic(item: MusicTableViewCell.Item) {
        let track = Track(
            trackId: item.trackId,
            trackName: item.musicName,
            artistName: item.artistName,
            artworkUrl100: item.image,
            trackTimeMillis: nil,
            previewUrl: item.previewUrl ?? ""
        )
        
        let tracks: [Track] = musicItems.compactMap {
            return Track(
                trackId: item.trackId,
                trackName: $0.musicName,
                artistName: $0.artistName,
                artworkUrl100: $0.image,
                trackTimeMillis: nil,
                previewUrl: $0.previewUrl ?? ""
            )
        }
        
        PlayerManager.shared.playHomeMusic(track, trackList: tracks)
    }

    func resetState() {
        musicItems = []
        podcastItems = []
        delegate?.showInitialState()
    }
}
