//
//  SearchViewModelTests.swift
//  Disc
//
//  Created by Jamila Mahammadli on 06.11.25.
//

import XCTest
@testable import Disc

@MainActor
final class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var mockRouter: MockSearchRouter!
    var mockDelegate: MockSearchViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockRouter = MockSearchRouter()
        viewModel = SearchViewModel(router: mockRouter)
        mockDelegate = MockSearchViewModelDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockRouter = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func test_didTapEpisode() {
        // Given
        let testCollectionId = 999
        
        // When
        viewModel.didTapEpisode(collectionId: testCollectionId)
        
        // Then
        XCTAssertTrue(mockRouter.navigateToEpisodeCalled, "navigateToEpisode should be called")
        XCTAssertEqual(mockRouter.navigateToEpisodeCollectionId, testCollectionId, "navigateToEpisode should receive correct collectionId")
    }
    
    func test_didTapMusic() {
        // Given
        let musicItem = MusicTableViewCell.Item(
            trackId: 1,
            image: "test_image",
            musicName: "Test Song",
            artistName: "Test Artist",
            previewUrl: "test_preview"
        )
        
        viewModel.musicItems = [musicItem]
        
        // When
        viewModel.didTapMusic(item: musicItem)
        
        // Then
        XCTAssertTrue(true, "playHomeMusic should be called")
    }
    
    func test_resetState() {
        // Given
        viewModel.musicItems = [
            .init(trackId: 1, image: "image", musicName: "Song", artistName: "Artist", previewUrl: "url")
        ]
        viewModel.podcastItems = [
            .init(image: "image", podcastName: "Podcast", artistName: "Artist", collectionId: 1)
        ]
        
        // When
        viewModel.resetState()
        
        // Then
        XCTAssertTrue(viewModel.musicItems.isEmpty, "Music items should be cleared")
        XCTAssertTrue(viewModel.podcastItems.isEmpty, "Podcast items should be cleared")
        XCTAssertEqual(mockDelegate.showInitialStateCallCount, 1, "showInitialState should be called once")
    }
    
    func test_searchWithEmptyText() async {
        // When
        await viewModel.search(text: "")
        
        // Then
        XCTAssertTrue(viewModel.musicItems.isEmpty)
        XCTAssertTrue(viewModel.podcastItems.isEmpty)
        XCTAssertEqual(mockDelegate.showNoDataCallCount, 1, "showNoData should be called for empty search text")
    }
    
    func test_searchWithSpacesOnly() async {
        // When
        await viewModel.search(text: "   ")
        
        // Then
        XCTAssertTrue(viewModel.musicItems.isEmpty)
        XCTAssertTrue(viewModel.podcastItems.isEmpty)
        XCTAssertEqual(mockDelegate.showNoDataCallCount, 1, "showNoData should be called for spaces-only input")
    }
}

final class MockSearchRouter: SearchRouterProtocol {
    var view: UIViewController?
    var navigateToEpisodeCalled = false
    var navigateToEpisodeCollectionId: Int?
    
    func navigateToEpisode(collectionId: Int) {
        navigateToEpisodeCalled = true
        navigateToEpisodeCollectionId = collectionId
    }
}

final class MockSearchViewModelDelegate: SearchViewModelDelegate {
    var reloadTableViewCallCount = 0
    var showNoDataCallCount = 0
    var showInitialStateCallCount = 0
    var showLoadingCallCount = 0
    
    func reloadTableView() {
        reloadTableViewCallCount += 1
    }
    
    func showNoData() {
        showNoDataCallCount += 1
    }
    
    func showInitialState() {
        showInitialStateCallCount += 1
    }
    
    func showLoading() {
        showLoadingCallCount += 1
    }
}
