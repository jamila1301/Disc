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
            let musicTracks = try await ITunesService.shared.fetchMusic(term: "music", limit: 200)
            self.cellTypes = musicTracks.map { track in
                    .music(.init(
                        image: track.artworkUrl100,
                        musicName: track.trackName,
                        artistName: track.artistName
                    ))
            }
            self.delegate?.reloadTableView()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

