//
//  MusicViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import Foundation

protocol MusicViewModelDelegate: AnyObject {
    func reloadTableView()
}

@MainActor
final class MusicViewModel {
    private var router: MusicRouterProtocol
    weak var delegate: MusicViewModelDelegate? = nil
    private(set) var items: [MusicTableViewCell.Item] = []
    
    init(router: MusicRouterProtocol) {
        self.router = router
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            let musicTracks = try await DIContainer.shared.networkService.fetchMusic(term: "music", limit: 199)
            self.items = musicTracks.map { track in
                MusicTableViewCell.Item(
                    trackId: track.trackId,
                    image: track.artworkUrl100,
                    musicName: track.trackName,
                    artistName: track.artistName,
                    previewUrl: track.previewUrl
                )
            }
            self.delegate?.reloadTableView()
            
        } catch {
            print(error.localizedDescription)
        }
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
        
        let tracks: [Track] = items.map { item in
            Track(
                trackId: item.trackId,
                trackName: item.musicName,
                artistName: item.artistName,
                artworkUrl100: item.image,
                trackTimeMillis: nil,
                previewUrl: item.previewUrl ?? ""
            )
        }
        
        DIContainer.shared.playerManager.playHomeMusic(track, trackList: tracks)
    }
}

