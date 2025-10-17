//
//  CategoryBuilder.swift
//  Disc
//
//  Created by Jamila Mahammadli on 17.10.25.
//

import UIKit

final class CategoryBuilder {
    
    func build() -> UIViewController {
        let router = CategoryRouter()
        let viewModel = CategoryViewModel(router: router)
        
        let vc = CategoryViewController(viewModel: viewModel)
        router.view = vc
        
        return vc
    }
}
