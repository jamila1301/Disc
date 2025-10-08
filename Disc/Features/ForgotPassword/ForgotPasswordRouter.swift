//
//  ForgotPasswordRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

protocol ForgotPasswordRouterProtocol {
    var view: UIViewController? { get set }
    
    @MainActor
    func showResetSuccess()
}

final class ForgotPasswordRouter: ForgotPasswordRouterProtocol {
    weak var view: UIViewController? = nil
    
    @MainActor
    func showResetSuccess() {
        let vc = PasswordResetSuccessViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        view?.present(vc, animated: true)
    }
}
