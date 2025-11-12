//
//  FavoriteViewModelTests.swift
//  Disc
//
//  Created by Jamila Mahammadli on 06.11.25.
//

import XCTest
@testable import Disc

@MainActor
final class FavoriteViewModelTests: XCTestCase {
    
    private var viewModel: FavoriteViewModel!
    private var mockRouter: MockFavoriteRouter!
    
    override func setUp() {
        super.setUp()
        mockRouter = MockFavoriteRouter()
        viewModel = FavoriteViewModel(router: mockRouter)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func test_setupFavorites_initialValues() {
        // Given
        let items = viewModel.favoriteList
        
        // Then
        XCTAssertEqual(items.count, 2, "Favorite list should contain 2 items")
        XCTAssertEqual(items[0].title, "collection_liked_musics".localized(), "First item should be localized liked musics title")
        XCTAssertEqual(items[1].title, "collection_liked_episodes".localized(), "Second item should be localized liked episodes title")
    }
    
    func test_didSelectFavoriteItem_navigateToLikedMusics() {
        // Given
        let likedMusicItem = FavoriteCollectionViewCell.Item(image: .frame, title: "collection_liked_musics".localized())
        
        // When
        viewModel.didSelectFavoriteItem(item: likedMusicItem)
        
        // Then
        XCTAssertTrue(mockRouter.didNavigateToLikedMusics, "Router should navigate to liked musics screen")
        XCTAssertFalse(mockRouter.didNavigateToLikedEpisodes, "Router should not navigate to liked episodes screen")
    }
    
    func test_didSelectFavoriteItem_navigateToLikedEpisodes() {
        // Given
        let likedEpisodeItem = FavoriteCollectionViewCell.Item(image: .frame, title: "collection_liked_episodes".localized())
        
        // When
        viewModel.didSelectFavoriteItem(item: likedEpisodeItem)
        
        // Then
        XCTAssertTrue(mockRouter.didNavigateToLikedEpisodes, "Router should navigate to liked episodes screen")
        XCTAssertFalse(mockRouter.didNavigateToLikedMusics, "Router should not navigate to liked musics screen")
    }
    
    func test_didSelectFavoriteItem_invalidTitle_doesNotNavigate() {
        // Given
        let invalidItem = FavoriteCollectionViewCell.Item(image: .frame, title: "unknown")
        
        // When
        viewModel.didSelectFavoriteItem(item: invalidItem)
        
        // Then
        XCTAssertFalse(mockRouter.didNavigateToLikedMusics, "Router should not navigate anywhere for unknown title")
        XCTAssertFalse(mockRouter.didNavigateToLikedEpisodes, "Router should not navigate anywhere for unknown title")
    }
}

final class MockFavoriteRouter: FavoriteRouterProtocol {
    var view: UIViewController?
    
    private(set) var didNavigateToLikedMusics = false
    private(set) var didNavigateToLikedEpisodes = false
    
    func navigateToLikedMusics() {
        didNavigateToLikedMusics = true
    }
    
    func navigateToLikedEpisodes() {
        didNavigateToLikedEpisodes = true
    }
}
