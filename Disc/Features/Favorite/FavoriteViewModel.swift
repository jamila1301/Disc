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
        
        DIContainer.shared.languageManager.addLanguageChangeListener { [weak self] in
            self?.setupFavorites()
        }

    }
    
    private func setupFavorites() {
        self.favoriteList = [
            .init(image: .frame, title: "collection_liked_musics".localized()),
            .init(image: .frame, title: "collection_liked_episodes".localized())
        ]
    }
    
    func didSelectFavoriteItem(item: FavoriteCollectionViewCell.Item) {
        switch item.title {
        case "collection_liked_musics".localized():
            router.navigateToLikedMusics()
        case "collection_liked_episodes".localized():
            router.navigateToLikedEpisodes()
        default:
            break
        }
    }
}
