//
//  ProfileRouter.swift
//  Disc
//
//  Created by Jamila Mahammadli on 26.10.25.
//

import UIKit

protocol ProfileRouterProtocol {
    var view: UIViewController? { get set }
    
    func navigateToAccount()
    func navigateToAbout()
    func navigateToTerms()
    func navigateToLanguage()
}

final class ProfileRouter: ProfileRouterProtocol {
    weak var view: UIViewController? = nil
    
    func navigateToAccount() {
        let vc = AccountViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAbout() {
        let vc = AboutViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToTerms() {
        let vc = TermsAndConditionsViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToLanguage() {
        let vc = LanguageViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        view?.present(vc, animated: true)
    }
}
