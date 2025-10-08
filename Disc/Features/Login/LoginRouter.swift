//
//  LoginRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import UIKit

protocol LoginRouterProtocol {
    var view: UIViewController? { get set }
    
    @MainActor
    func navigateHome()
    @MainActor
    func navigateToForgotPassword()
    @MainActor
    func navigateToSignup()
}

final class LoginRouter: LoginRouterProtocol {
    weak var view: UIViewController? = nil
    
    @MainActor
    func navigateHome() {
        let tabBar = HomeViewController()
        view?.navigationController?.setViewControllers([tabBar], animated: true)
    }
    
    @MainActor
    func navigateToForgotPassword() {
        let forgotVC = ForgotPasswordBuilder().build()
        view?.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @MainActor
    func navigateToSignup() {
        let signupVC = SignupBuilder().build()
        view?.navigationController?.pushViewController(signupVC, animated: true)
    }
}
