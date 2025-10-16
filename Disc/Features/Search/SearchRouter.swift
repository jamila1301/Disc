//
//  SearchRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 15.10.25.
//

import UIKit

protocol SearchRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
    func navigateToEpisode(collectionId: Int)
}

final class SearchRouter: SearchRouterProtocol {
    weak var view: UIViewController?
    
    func navigateToEpisode(collectionId: Int) {
        let vc = EpisodeBuilder().build(collectionId: collectionId)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
