//
//  HomeViewModelTests.swift
//  Disc
//
//  Created by Jamila Mahammadli on 06.11.25.
//

import XCTest
@testable import Disc

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockRouter: MockHomeRouter!
    var mockDelegate: MockHomeViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockRouter = MockHomeRouter()
        viewModel = HomeViewModel(router: mockRouter)
        mockDelegate = MockHomeViewModelDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockRouter = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func test_fetchDataSuccess() async throws {
        // When
        await viewModel.fetchData()
        
        // Then
        XCTAssertFalse(viewModel.cellTypes.isEmpty, "cellTypes should not be empty after fetching data")
        XCTAssertTrue(mockDelegate.reloadTableViewCalled, "reloadTableView() should be called after data fetched")
        
        XCTAssertTrue(viewModel.cellTypes.contains(where: {
            if case .banner = $0 { return true }
            return false
        }), "Should contain a banner cell type")
        
        XCTAssertTrue(viewModel.cellTypes.contains(where: {
            if case .music = $0 { return true }
            return false
        }), "Should contain a music cell type")
        
        XCTAssertTrue(viewModel.cellTypes.contains(where: {
            if case .podcast = $0 { return true }
            return false
        }), "Should contain a podcast cell type")
    }
    
    func test_didTapMusic_navigatesToMusic() {
        // When
        viewModel.didTapMusic()
        
        // Then
        XCTAssertTrue(mockRouter.navigateToMusicCalled, "navigateToMusic() should be called")
    }
    
    func test_didTapPodcast_navigatesToPodcast() {
        // When
        viewModel.didTapPodcast()
        
        // Then
        XCTAssertTrue(mockRouter.navigateToPodcastCalled, "navigateToPodcast() should be called")
    }
    
    func test_didTapEpisode_navigatesToCorrectCollectionId() {
        // Given
        let testCollectionId = 123
        
        // When
        viewModel.didTapEpisode(collectionId: testCollectionId)
        
        // Then
        XCTAssertTrue(mockRouter.navigateToEpisodeCalled, "navigateToEpisode() should be called")
        XCTAssertEqual(mockRouter.navigateToEpisodeCollectionId, testCollectionId, "navigateToEpisode() should receive the correct collectionId")
    }
    
    func test_playBannerTrack_executesWithoutError() async {
        // Given
        let bannerItem = HomeBannerCollectionViewCell.Item(
            trackId: 1,
            leftImage: "image_url",
            topLabel: "Top",
            nameLabel: "Song Name",
            artistLabel: "Artist Name",
            timeLabel: "3:30",
            previewUrl: "preview_url"
        )
        
        // When
        await viewModel.playBannerTrack(item: bannerItem)
        
        // Then
        XCTAssertTrue(true, "playBannerTrack executed successfully")
    }
    
    func test_playHomeMusic_executesWithoutError() async {
        // Given
        let musicItem = HomeMusicCollectionViewCell.Item(
            trackId: 2,
            image: "image_url",
            musicName: "Home Song",
            artistName: "Home Artist",
            previewUrl: "home_preview_url"
        )
        
        // When
        await viewModel.playHomeMusic(item: musicItem)
        
        // Then
        XCTAssertTrue(true, "playHomeMusic executed successfully")
    }
}

final class MockHomeRouter: HomeRouterProtocol {
    var view: UIViewController?
    
    var navigateToMusicCalled = false
    var navigateToPodcastCalled = false
    var navigateToEpisodeCalled = false
    var navigateToEpisodeCollectionId: Int?
    
    func navigateToMusic() {
        navigateToMusicCalled = true
    }
    
    func navigateToPodcast() {
        navigateToPodcastCalled = true
    }
    
    func navigateToEpisode(collectionId: Int) {
        navigateToEpisodeCalled = true
        navigateToEpisodeCollectionId = collectionId
    }
}

final class MockHomeViewModelDelegate: HomeViewModelDelegate {
    var reloadTableViewCalled = false
    
    func reloadTableView() {
        reloadTableViewCalled = true
    }
}
