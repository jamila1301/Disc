//
//  MusicListBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 17.10.25.
//

import UIKit

final class MusicListBuilder {
    
    func build(category: String) -> UIViewController {
        let router = MusicListRouter()
        let viewModel = MusicListViewModel(category: category, router: router)
        
        let vc = MusicListViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
