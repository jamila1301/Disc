//
//  ProfileBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 26.10.25.
//

import UIKit

final class ProfileBuilder {
    
    func build() -> UIViewController {
        let router = ProfileRouter()
        let viewModel = ProfileViewModel(router: router)
        
        let vc = ProfileViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
