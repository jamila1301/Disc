//
//  CategoryViewModel.swift
//  Disc
//
//  Created by Jamila Mahammadli on 17.10.25.
//

import Foundation
import UIKit

protocol CategoryViewModelDelegate: AnyObject {
    func reloadTableView()
}

final class CategoryViewModel {
    
    weak var delegate: CategoryViewModelDelegate? = nil
    private let router: CategoryRouterProtocol
    
    let categories: [CategoryCollectionViewCell.Item] = [
        "Pop","Hip-Hop","Rock","Jazz","Metal","K-pop","Rap",
        "Electronic","Classical","Blues","Latin","R&B/Soul","Folk","Reggae"
    ].map { CategoryCollectionViewCell.Item(categoryName: $0) }
    
    let colors: [CategoryColor] = CategoryColor.allCases
    
    init(router: CategoryRouterProtocol) {
        self.router = router
    }
    
    func didSelectCategory(index: Int) {
        let category = categories[index].categoryName
        router.openMusicList(category: category)
    }
    
}

enum CategoryColor: CaseIterable {
    case red, blue, purple, orange, gray, darkPurple, darkOrange, violet, pink, teal, navy, green, olive, darkOrangeAlt
    
    var uiColor: UIColor {
        switch self {
        case .red: return UIColor(named: "CategoryRedColor") ?? .red
        case .blue: return UIColor(named: "CategoryBlueColor") ?? .blue
        case .purple: return UIColor(named: "CategoryPurpleColor") ?? .purple
        case .orange: return UIColor(named: "CategoryOrangeColor") ?? .orange
        case .gray: return UIColor(named: "CategoryGrayColor") ?? .gray
        case .darkPurple: return UIColor(named: "CategoryDarkPurpleColor") ?? .purple
        case .darkOrange: return UIColor(named: "CategoryDarkOrangeColor") ?? .orange
        case .violet: return UIColor(named: "CategoryVioletColor") ?? .purple
        case .pink: return UIColor(named: "CategoryPinkColor") ?? .systemPink
        case .teal: return UIColor(named: "CategoryTealColor") ?? .systemTeal
        case .navy: return UIColor(named: "CategoryNavyColor") ?? .blue
        case .green: return UIColor(named: "CategoryGreenColor") ?? .green
        case .olive: return UIColor(named: "CategoryOliveColor") ?? .brown
        case .darkOrangeAlt: return UIColor(named: "CategoryDarkOrangeAltColor") ?? .orange
        }
    }
}
