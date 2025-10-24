//
//  FavoriteBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 23.10.25.
//

import UIKit

final class FavoriteBuilder {
    func build() -> UIViewController {
        let router = FavoriteRouter()
        let viewModel = FavoriteViewModel(router: router)
        
        let vc = FavoriteViewController(viewModel: viewModel)
        router.view = vc
        return vc
    }
}
