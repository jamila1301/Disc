//
//  LikedEpisodeBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import UIKit

final class LikedEpisodeBuilder {
    
    func build() -> UIViewController {
        let router = LikedEpisodeRouter()
        let viewModel = LikedEpisodeViewModel(router: router)
        
        let vc = LikedEpisodeViewController(viewModel: viewModel)
        router.view = vc
        return vc
    }
}
