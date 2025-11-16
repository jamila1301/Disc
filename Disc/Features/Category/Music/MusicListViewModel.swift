//
//  MusicListViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 17.10.25.
//

import Foundation

protocol MusicListViewModelDelegate: AnyObject {
    func reloadTableView()
}

@MainActor
final class MusicListViewModel {
    private var router: MusicListRouterProtocol
    weak var delegate: MusicListViewModelDelegate? = nil
    private(set) var items: [MusicTableViewCell.Item] = []
    let category: String
    
    init(category: String, router: MusicListRouterProtocol) {
        self.category = category
        self.router = router
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            let musicTracks = try await DIContainer.shared.networkService.fetchMusic(term: category, limit: 200)
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
