//
//  CategoryViewModelTests.swift
//  Disc
//
//  Created by Jamila Mahammadli on 06.11.25.
//

import XCTest
@testable import Disc

@MainActor
final class CategoryViewModelTests: XCTestCase {
    
    private var viewModel: CategoryViewModel!
    private var mockRouter: MockCategoryRouter!
    private var mockDelegate: MockCategoryDelegate!
    
    override func setUp() {
        super.setUp()
        mockRouter = MockCategoryRouter()
        viewModel = CategoryViewModel(router: mockRouter)
        mockDelegate = MockCategoryDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockRouter = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func test_categoriesCount_matchesKeysCount() {
        // Given
        let expected = 14
        
        // When
        let actual = viewModel.categories.count
        
        // Then
        XCTAssertEqual(actual, expected, "categories count must equal keys count")
    }
    
    func test_colorsCount_matchesHardCodedCount() {
        // Given
        let expected = 14
        
        // When
        let actual = viewModel.colors.count
        
        // Then
        XCTAssertEqual(actual, expected, "colors string array count must be 14")
    }
    
    func test_didSelectCategory_callsRouterWithCorrectName() {
        // Given
        let index = 2
        let expected = viewModel.categories[index].categoryName
        
        // When
        viewModel.didSelectCategory(index: index)
        
        // Then
        XCTAssertEqual(mockRouter.openedCategory, expected, "router must receive correct category name")
    }
    
    func test_languageChange_triggersDelegateReload() {
        // Given
        XCTAssertFalse(mockDelegate.didReload, "pre-condition")
        
        // When
        LanguageManager.shared.set(language: .az)
        
        // Then
        XCTAssertTrue(mockDelegate.didReload, "delegate must be told to reload")
    }
}

final class MockCategoryRouter: CategoryRouterProtocol {
    weak var view: UIViewController?
    private(set) var openedCategory: String?
    
    func openMusicList(category: String) {
        openedCategory = category
    }
}

final class MockCategoryDelegate: CategoryViewModelDelegate {
    private(set) var didReload = false
    
    func reloadTableView() {
        didReload = true
    }
}
