//
//  CategoryRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 17.10.25.
//

import UIKit

protocol CategoryRouterProtocol {
    var view: UIViewController? { get set }
    func openMusicList(category: String)
}

final class CategoryRouter: CategoryRouterProtocol {
    weak var view: UIViewController? = nil
    
    func openMusicList(category: String) {
        let vc = MusicListBuilder().build(category: category)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
