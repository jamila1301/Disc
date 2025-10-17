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
                        artistName: track.artistName
                    ))
            }
            self.delegate?.reloadTableView()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

