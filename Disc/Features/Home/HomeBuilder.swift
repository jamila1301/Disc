//
//  HomeBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

final class HomeBuilder {
    
    func build() -> UIViewController {
        let router = HomeRouter()
        let viewModel = HomeViewModel(router: router)
        
        let vc = HomeViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
