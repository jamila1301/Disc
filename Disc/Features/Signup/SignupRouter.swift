//
//  SignupRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

protocol SignupRouterProtocol {
    var view: UIViewController? { get set }
    
    @MainActor
    func navigateHome()
    @MainActor
    func navigateToSignin()
}

final class SignupRouter: SignupRouterProtocol {
    weak var view: UIViewController? = nil
    
    @MainActor
    func navigateHome() {
        let tabBar = BaseTabBar()
        view?.navigationController?.setViewControllers([tabBar], animated: true)
    }
    
    @MainActor
    func navigateToSignin() {
        view?.navigationController?.popViewController(animated: true)
    }
}
