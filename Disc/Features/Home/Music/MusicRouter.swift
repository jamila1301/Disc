//
//  MusicRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

protocol MusicRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
}

final class MusicRouter: MusicRouterProtocol {
    weak var view: UIViewController? = nil
}
