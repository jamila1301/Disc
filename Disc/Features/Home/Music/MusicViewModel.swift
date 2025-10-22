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

enum MusicCellType {
    case music(MusicTableViewCell.Item)
}

@MainActor
final class MusicViewModel {
    private var router: MusicRouterProtocol
    weak var delegate: MusicViewModelDelegate? = nil
    private(set) var cellTypes: [MusicCellType] = []
    
    init(router: MusicRouterProtocol) {
        self.router = router
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            let musicTracks = try await ITunesService.shared.fetchMusic(term: "music", limit: 199)
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
                    trackName: item.musicName,
                    artistName: item.artistName,
                    artworkUrl100: item.image,
                    trackTimeMillis: nil,
                    previewUrl: item.previewUrl ?? ""
                )
            }
            return nil
        }
        
        PlayerManager.shared.playHomeMusic(track, trackList: tracks)
    }
}

