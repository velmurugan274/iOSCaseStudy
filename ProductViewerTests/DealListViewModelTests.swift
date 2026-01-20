//
//  DealListViewModelTests.swift
//  ProductViewerTests
//
//  Copyright © 2026 Target. All rights reserved.
//

import XCTest
import Combine
@testable import ProductViewer

@MainActor
final class DealListViewModelTests: XCTestCase {
    
    private var sut: DealListViewModel!
    private var mockFetchUseCase: MockFetchDealsUseCase!
    private var mockDelegate: MockDealListViewModelDelegate!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockFetchUseCase = MockFetchDealsUseCase()
        mockDelegate = MockDealListViewModelDelegate()
        sut = DealListViewModel(fetchDealsUseCase: mockFetchUseCase)
        sut.delegate = mockDelegate
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockFetchUseCase = nil
        mockDelegate = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Load Deals
    
    func testViewDidLoad_withDeals_shouldTransitionToLoadedState() async {
        // Given
        let expectedDeals = TestData.sampleDealsList
        mockFetchUseCase.result = .success(expectedDeals)
        
        let expectation = XCTestExpectation(description: "State should become loaded")
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded(let deals) = state {
                    XCTAssertEqual(deals, expectedDeals)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.viewDidLoad()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(mockFetchUseCase.executeCallCount, 1)
    }
    
    func testViewDidLoad_withEmptyDeals_shouldTransitionToEmptyState() async {
        // Given
        mockFetchUseCase.result = .success([])
        
        let expectation = XCTestExpectation(description: "State should become empty")
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if state == .empty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.viewDidLoad()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_withNetworkError_shouldTransitionToNetworkErrorState() async {
        // Given
        mockFetchUseCase.result = .failure(DomainError.networkUnavailable)
        
        let expectation = XCTestExpectation(description: "State should become networkError")
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if state == .networkError {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.viewDidLoad()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testViewDidLoad_withDomainError_shouldTransitionToErrorState() async {
        // Given
        mockFetchUseCase.result = .failure(DomainError.invalidData)
        
        let expectation = XCTestExpectation(description: "State should become error")
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.viewDidLoad()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    // MARK: - Refresh
    
    func testRefresh_shouldReloadDeals() async {
        // Given - Initial load
        mockFetchUseCase.result = .success(TestData.sampleDealsList)
        
        let loadExpectation = XCTestExpectation(description: "Initial load")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { loadExpectation.fulfill() }
            }
            .store(in: &cancellables)
        
        sut.viewDidLoad()
        await fulfillment(of: [loadExpectation], timeout: 2.0)
        
        // When - Refresh
        let refreshExpectation = XCTestExpectation(description: "Refresh")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { refreshExpectation.fulfill() }
            }
            .store(in: &cancellables)
        
        sut.refresh()
        
        // Then
        await fulfillment(of: [refreshExpectation], timeout: 2.0)
        XCTAssertEqual(mockFetchUseCase.executeCallCount, 2)
    }
    
    // MARK: - Deal Selection
    
    func testDidSelectDeal_withValidIndex_shouldNotifyDelegate() async {
        // Given
        let expectedDeals = TestData.sampleDealsList
        mockFetchUseCase.result = .success(expectedDeals)
        
        let expectation = XCTestExpectation(description: "Deals loaded")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { expectation.fulfill() }
            }
            .store(in: &cancellables)
        
        sut.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // When
        sut.didSelectDeal(at: 1)
        
        // Then
        XCTAssertEqual(mockDelegate.didSelectDealCallCount, 1)
        XCTAssertEqual(mockDelegate.selectedDeal, expectedDeals[1])
    }
    
    func testDidSelectDeal_withInvalidIndex_shouldNotNotifyDelegate() async {
        // Given
        mockFetchUseCase.result = .success(TestData.sampleDealsList)
        
        let expectation = XCTestExpectation(description: "Deals loaded")
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .loaded = state { expectation.fulfill() }
            }
            .store(in: &cancellables)
        
        sut.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // When
        sut.didSelectDeal(at: -1)
        sut.didSelectDeal(at: 100)
        
        // Then
        XCTAssertEqual(mockDelegate.didSelectDealCallCount, 0)
    }
    
    func testDidSelectDeal_beforeDealsLoaded_shouldNotNotifyDelegate() {
        // When
        sut.didSelectDeal(at: 0)
        
        // Then
        XCTAssertEqual(mockDelegate.didSelectDealCallCount, 0)
    }
}
