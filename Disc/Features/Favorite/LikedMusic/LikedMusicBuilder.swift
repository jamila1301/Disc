//
//  LikedMusicBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import UIKit

final class LikedMusicBuilder {
    
    func build() -> UIViewController {
        let router = LikedMusicRouter()
        let viewModel = LikedMusicViewModel(router: router)
        
        let vc = LikedMusicViewController(viewModel: viewModel)
        router.view = vc
        return vc
    }
}
