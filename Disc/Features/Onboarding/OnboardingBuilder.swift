//
//  OnboardingBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

final class OnboardingBuilder {
    
    func build() -> UIViewController {
        let router = OnboardingRouter()
        let viewModel = OnboardingViewModel(router: router)
        
        let vc = OnboardingViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
