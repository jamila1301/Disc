//
//  BaseTabBar.swift
//  Disc
//
//  Created by Jamila Mahammadli on 08.10.25.
//

import UIKit

final class BaseTabBar: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .screenBackground
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = .screenBackground
        navAppearance.titleTextAttributes = [
            .font: UIFont.plusJakartaSansSemiBold18!,
            .foregroundColor: UIColor.black
        ]
        navAppearance.shadowColor = .clear
        
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [
            .font: UIFont.plusJakartaSansRegular16!,
            .foregroundColor: UIColor.black
        ]
        navAppearance.backButtonAppearance = backButtonAppearance

        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = .screenBackground
        tabAppearance.stackedLayoutAppearance.selected.iconColor = .defaultBlue
        tabAppearance.stackedLayoutAppearance.normal.iconColor = .iconBackground
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        
        let homeVC = HomeBuilder().build()
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        homeNavVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .home,
            selectedImage: .homeFill
        )
        
        let searchVC = SearchBuilder().build()
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        searchNavVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .search,
            selectedImage: .searchFill
        )
        
        let categoryVC = CategoryBuilder().build()
        let categoryNavVC = UINavigationController(rootViewController: categoryVC)
        categoryNavVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .category,
            selectedImage: .categoryFill
        )
        
        let favoriteVC = FavoriteViewController()
        let favoriteNavVC = UINavigationController(rootViewController: favoriteVC)
        favoriteNavVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .favorite,
            selectedImage: .favoriteFill
        )
        
        let profileVC = ProfileViewController()
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        profileNavVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .profile,
            selectedImage: .profileFill
        )
        
        setViewControllers([homeNavVC, searchNavVC, categoryNavVC, favoriteNavVC, profileNavVC], animated: false)
    }
    
}

