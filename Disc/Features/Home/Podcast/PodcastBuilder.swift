//
//  PodcastBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

final class PodcastBuilder {
    
    func build() -> UIViewController {
        let router = PodcastRouter()
        let viewModel = PodcastViewModel(router: router)
        
        let vc = PodcastViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
