//
//  MusicBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

final class MusicBuilder {
    
    func build() -> UIViewController {
        let router = MusicRouter()
        let viewModel = MusicViewModel(router: router)
        
        let vc = MusicViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
