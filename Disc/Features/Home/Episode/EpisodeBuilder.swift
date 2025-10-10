//
//  EpisodeBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 10.10.25.
//

import UIKit

final class EpisodeBuilder {
    
    func build(collectionId: Int) -> UIViewController {
        let router = EpisodeRouter()
        let viewModel = EpisodeViewModel(collectionId: collectionId, router: router)
        
        let vc = EpisodeViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
