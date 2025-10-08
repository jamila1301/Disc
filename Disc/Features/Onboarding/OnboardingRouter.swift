//
//  OnboardingRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

protocol OnboardingRouterProtocol {
    var view: UIViewController? { get set }
    
    @MainActor
    func navigateToLogin()
}

final class OnboardingRouter: OnboardingRouterProtocol {
    weak var view: UIViewController? = nil
    
    @MainActor
    func navigateToLogin() {
        let loginVC = LoginBuilder().build()
        view?.navigationController?.pushViewController(loginVC, animated: true)
    }
}
