//
//  LikedMusicRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import UIKit

protocol LikedMusicRouterProtocol {
    var view: UIViewController? { get set }
}

final class LikedMusicRouter: LikedMusicRouterProtocol {
    weak var view: UIViewController? = nil
}
