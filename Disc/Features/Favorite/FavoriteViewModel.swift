//
//  FavoriteViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import Foundation

@MainActor
final class FavoriteViewModel {
    
    private let router: FavoriteRouterProtocol
    private(set) var favoriteList: [FavoriteCollectionViewCell.Item] = []
    
    init(router: FavoriteRouterProtocol) {
        self.router = router
        setupFavorites()
    }
    
    private func setupFavorites() {
        self.favoriteList = [
            .init(image: .frame, title: "Liked Musics"),
            .init(image: .frame, title: "Liked Episodes")
        ]
    }
    
    func didSelectFavoriteItem(item: FavoriteCollectionViewCell.Item) {
        switch item.title {
        case "Liked Musics":
            router.navigateToLikedMusics()
        case "Liked Episodes":
            router.navigateToLikedEpisodes()
        default:
            break
        }
    }
}
