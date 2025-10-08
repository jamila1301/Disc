//
//  ForgotPasswordBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

final class ForgotPasswordBuilder {
    
    func build() -> UIViewController {
        let router = ForgotPasswordRouter()
        let viewModel = ForgotPasswordViewModel(router: router)
        
        let vc = ForgotPasswordViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
