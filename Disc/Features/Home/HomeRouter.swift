//
//  HomeRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

protocol HomeRouterProtocol {
    var view: UIViewController? { get set }
    
    func navigateToMusic()
    func navigateToPodcast()
    func navigateToEpisode(collectionId: Int)
}

final class HomeRouter: HomeRouterProtocol {
    weak var view: UIViewController? = nil
    
    func navigateToMusic() {
        let vc = MusicBuilder().build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToPodcast() {
        let vc = PodcastBuilder().build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToEpisode(collectionId: Int) {
        let vc = EpisodeBuilder().build(collectionId: collectionId)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
