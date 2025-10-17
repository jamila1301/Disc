//
//  MusicListRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 17.10.25.
//

import UIKit

protocol MusicListRouterProtocol {
    var view: UIViewController? { get set }
}

final class MusicListRouter: MusicListRouterProtocol {
    weak var view: UIViewController? = nil
}
