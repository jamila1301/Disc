//
//  CategoryViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 17.10.25.
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func reloadTableView()
}

final class CategoryViewModel {
    
    weak var delegate: CategoryViewModelDelegate? = nil
    private let router: CategoryRouterProtocol
    
    private let categoryKeys: [String] = [
        "category_pop","category_hip_hop","category_rock","category_jazz","category_metal",
        "category_k_pop","category_rap", "category_electronic","category_classical",
        "category_blues","category_latin","category_rnb_soul","category_folk","category_reggae"
    ]
    
    var categories: [CategoryCollectionViewCell.Item] {
        categoryKeys.map { CategoryCollectionViewCell.Item(categoryName: $0.localized()) }
    }
    
    let colors: [String] = [
        "CategoryRedColor", "CategoryBlueColor", "CategoryPurpleColor",
        "CategoryOrangeColor", "CategoryGrayColor", "CategoryDarkPurpleColor",
        "CategoryDarkOrangeColor", "CategoryVioletColor", "CategoryPinkColor",
        "CategoryTealColor", "CategoryNavyColor", "CategoryGreenColor",
        "CategoryOliveColor", "CategoryDarkOrangeAltColor"
    ]
    
    init(router: CategoryRouterProtocol) {
        self.router = router
        
        LanguageManager.shared.addLanguageChangeListener { [weak self] in
            self?.delegate?.reloadTableView()
        }
    }
    
    func didSelectCategory(index: Int) {
        let category = categories[index].categoryName
        router.openMusicList(category: category)
    }
    
}
