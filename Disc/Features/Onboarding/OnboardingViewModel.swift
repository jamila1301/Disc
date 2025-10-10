//
//  OnboardingViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import Foundation

protocol OnboardingViewModelProtocol {
    func startExploring()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    private var router: OnboardingRouterProtocol
    
    init(router: OnboardingRouterProtocol) {
        self.router = router
    }
    
    func startExploring() {
        router.navigateToLogin()
    }
}
