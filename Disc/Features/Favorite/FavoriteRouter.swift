//
//  FavoriteRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import UIKit

protocol FavoriteRouterProtocol {
    var view: UIViewController? { get set }
    
    func navigateToLikedMusics()
    func navigateToLikedEpisodes()
}

final class FavoriteRouter: FavoriteRouterProtocol {
    weak var view: UIViewController? = nil
    
    func navigateToLikedMusics() {
        let vc = LikedMusicBuilder().build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToLikedEpisodes() {
        let vc = LikedEpisodeBuilder().build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
