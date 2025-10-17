//
//  PodcastRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

protocol PodcastRouterProtocol {
    var view: UIViewController? { get set }
    
    func navigateToEpisode(collectionId: Int)
}

final class PodcastRouter: PodcastRouterProtocol {
    weak var view: UIViewController? = nil
    
    func navigateToEpisode(collectionId: Int) {
        let vc = EpisodeBuilder().build(collectionId: collectionId)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
