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
    
    var viewModel: CategoryViewModel!
    var mockRouter: MockCategoryRouter!
    var mockDelegate: MockCategoryDelegate!
    
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
    
    func test_categoriesCount_shouldMatchCategoryKeys() {
        // Given
        let expectedCount = 14
        
        // When
        let count = viewModel.categories.count
        
        // Then
        XCTAssertEqual(count, expectedCount, "Category count should be \(expectedCount)")
    }
    
    func test_colorsCount_shouldMatchAllCases() {
        // Given
        let expectedCount = CategoryColor.allCases.count
        
        // When
        let count = viewModel.colors.count
        
        // Then
        XCTAssertEqual(count, expectedCount, "Colors count should match allCases count")
    }
    
    func test_didSelectCategory_shouldCallRouterWithCorrectCategory() {
        // Given
        let indexToSelect = 0
        let expectedCategory = viewModel.categories[indexToSelect].categoryName
        
        // When
        viewModel.didSelectCategory(index: indexToSelect)
        
        // Then
        XCTAssertEqual(mockRouter.openedCategory, expectedCategory, "Router should be called with correct category")
    }
    
    func test_languageChange_shouldTriggerDelegateReload() {
        // Given
        XCTAssertFalse(mockDelegate.didReload)
        
        // When
        LanguageManager.shared.set(language: .az)
        
        // Then
        XCTAssertTrue(mockDelegate.didReload, "Delegate should reload tableView after language change")
    }
}

final class MockCategoryRouter: CategoryRouterProtocol {
    var view: UIViewController?
    var openedCategory: String?
    
    func openMusicList(category: String) {
        openedCategory = category
    }
}

final class MockCategoryDelegate: CategoryViewModelDelegate {
    var didReload = false
    
    func reloadTableView() {
        didReload = true
    }
}
