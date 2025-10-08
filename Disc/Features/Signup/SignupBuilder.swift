//
//  SignupBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

final class SignupBuilder {
    
    func build() -> UIViewController {
        let router = SignupRouter()
        let viewModel = SignupViewModel(router: router)
        
        let vc = SignupViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
