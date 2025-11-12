//
//  ProfileViewModelTests.swift
//  Disc
//
//  Created by Jamila Mahammadli on 11.11.25.
//

import XCTest
@testable import Disc

@MainActor
final class ProfileViewModelTests: XCTestCase {
    
    private var viewModel: ProfileViewModel!
    private var mockRouter: MockProfileRouter!
    private var mockDelegate: MockProfileDelegate!
    
    override func setUp() {
        super.setUp()
        mockRouter = MockProfileRouter()
        viewModel = ProfileViewModel(router: mockRouter)
        mockDelegate = MockProfileDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockRouter = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func test_didTapAccount_callsNavigateToAccount() {
        // When
        viewModel.didTapAccount()
        
        // Then
        XCTAssertTrue(mockRouter.didNavigateToAccount, "Router should navigate to Account screen")
        XCTAssertFalse(mockRouter.didNavigateToAbout, "Other routes should not be triggered")
        XCTAssertFalse(mockRouter.didNavigateToTerms)
        XCTAssertFalse(mockRouter.didNavigateToLanguage)
    }
    
    func test_didTapAbout_callsNavigateToAbout() {
        // When
        viewModel.didTapAbout()
        
        // Then
        XCTAssertTrue(mockRouter.didNavigateToAbout, "Router should navigate to About screen")
        XCTAssertFalse(mockRouter.didNavigateToAccount)
        XCTAssertFalse(mockRouter.didNavigateToTerms)
        XCTAssertFalse(mockRouter.didNavigateToLanguage)
    }
    
    func test_didTapTerms_callsNavigateToTerms() {
        // When
        viewModel.didTapTerms()
        
        // Then
        XCTAssertTrue(mockRouter.didNavigateToTerms, "Router should navigate to Terms screen")
        XCTAssertFalse(mockRouter.didNavigateToAccount)
        XCTAssertFalse(mockRouter.didNavigateToAbout)
        XCTAssertFalse(mockRouter.didNavigateToLanguage)
    }
    
    func test_didTapLanguage_callsNavigateToLanguage() {
        // When
        viewModel.didTapLanguage()
        
        // Then
        XCTAssertTrue(mockRouter.didNavigateToLanguage, "Router should navigate to Language screen")
        XCTAssertFalse(mockRouter.didNavigateToAccount)
        XCTAssertFalse(mockRouter.didNavigateToAbout)
        XCTAssertFalse(mockRouter.didNavigateToTerms)
    }
    
    func test_initialCellTypes_isEmpty() {
        // Then
        XCTAssertTrue(viewModel.cellTypes.isEmpty, "Initially cellTypes should be empty before Firestore data loads")
    }
    
    func test_removeListener_doesNotCrash() {
        // When
        viewModel.removeListener()
        
        // Then
        XCTAssertTrue(true)
    }
}

final class MockProfileRouter: ProfileRouterProtocol {
    var view: UIViewController?
    
    private(set) var didNavigateToAccount = false
    private(set) var didNavigateToAbout = false
    private(set) var didNavigateToTerms = false
    private(set) var didNavigateToLanguage = false
    
    func navigateToAccount() {
        didNavigateToAccount = true
    }
    
    func navigateToAbout() {
        didNavigateToAbout = true
    }
    
    func navigateToTerms() {
        didNavigateToTerms = true
    }
    
    func navigateToLanguage() {
        didNavigateToLanguage = true
    }
}

final class MockProfileDelegate: ProfileViewModelDelegate {
    private(set) var didReloadTableView = false
    
    func reloadTableView() {
        didReloadTableView = true
    }
}
