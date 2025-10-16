//
//  SearchBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 15.10.25.
//

import UIKit

final class SearchBuilder {
    func build() -> UIViewController {
        let router = SearchRouter()
        let viewModel = SearchViewModel(router: router)
        
        let vc = SearchViewController(viewModel: viewModel)
        router.view = vc
        return vc
    }
}
