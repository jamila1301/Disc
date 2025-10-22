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

enum MusicListCellType {
    case music(MusicTableViewCell.Item)
}

@MainActor
final class MusicListViewModel {
    private var router: MusicListRouterProtocol
    weak var delegate: MusicListViewModelDelegate? = nil
    private(set) var cellTypes: [MusicListCellType] = []
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
            let musicTracks = try await ITunesService.shared.fetchMusic(term: category, limit: 200)
            self.cellTypes = musicTracks.map { track in
                    .music(.init(
                        image: track.artworkUrl100,
                        musicName: track.trackName,
                        artistName: track.artistName,
                        previewUrl: track.previewUrl
                    ))
            }
            self.delegate?.reloadTableView()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didTapMusic(item: MusicTableViewCell.Item) {
        let track = Track(
            trackName: item.musicName,
            artistName: item.artistName,
            artworkUrl100: item.image,
            trackTimeMillis: nil,
            previewUrl: item.previewUrl ?? ""
        )
        
        let tracks: [Track] = cellTypes.compactMap {
            if case .music(let item) = $0 {
                return Track(
                    trackName: item.musicName ,
                    artistName: item.artistName ,
                    artworkUrl100: item.image ,
                    trackTimeMillis: nil,
                    previewUrl: item.previewUrl ?? ""
                )
            }
            return nil
        }
        
        PlayerManager.shared.playHomeMusic(track, trackList: tracks)
    }

}
