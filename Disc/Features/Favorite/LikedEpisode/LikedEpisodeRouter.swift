//
//  LikedEpisodeRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import UIKit

protocol LikedEpisodeRouterProtocol {
    var view: UIViewController? { get set }
}

final class LikedEpisodeRouter: LikedEpisodeRouterProtocol {
    weak var view: UIViewController? = nil
}
