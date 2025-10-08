//
//  LoginBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 07.10.25.
//

import UIKit

final class LoginBuilder {
    
    func build() -> UIViewController {
        let router = LoginRouter()
        let viewModel = LoginViewModel(router: router)
        
        let vc = LoginViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
