//
//  EpisodeRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

protocol EpisodeRouterProtocol {
    var view: UIViewController? { get set }
}

final class EpisodeRouter: EpisodeRouterProtocol {
    weak var view: UIViewController? = nil
}
