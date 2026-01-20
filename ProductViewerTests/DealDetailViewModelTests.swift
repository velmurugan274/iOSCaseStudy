//
//  DealDetailViewModelTests.swift
//  ProductViewerTests
//
//  Copyright © 2026 Target. All rights reserved.
//

import XCTest
import Combine
@testable import ProductViewer

@MainActor
final class DealDetailViewModelTests: XCTestCase {
    
    private var sut: DealDetailViewModel!
    private var mockGetDetailUseCase: MockGetDealDetailUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockGetDetailUseCase = MockGetDealDetailUseCase()
        sut = DealDetailViewModel(
            deal: TestData.sampleDeal,
            getDealDetailUseCase: mockGetDetailUseCase
        )
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockGetDetailUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State
    
    func testInitialState_shouldHaveCorrectDefaults() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(sut.deal, TestData.sampleDeal)
        XCTAssertEqual(sut.quantity, 0)
        XCTAssertFalse(sut.isInCart)
    }
    
    // MARK: - Load Data
    
    func testLoadData_onSuccess_shouldUpdateStateAndDeal() async {
        // Given
        let detailedDeal = TestData.sampleDealOnSale
        mockGetDetailUseCase.result = .success(detailedDeal)
        
        let expectation = XCTestExpectation(description: "State should become loaded")
        
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded(let deal) = state {
                    XCTAssertEqual(deal, detailedDeal)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.loadData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(sut.deal, detailedDeal)
        XCTAssertEqual(mockGetDetailUseCase.lastRequestedId, TestData.sampleDeal.id)
    }
    
    func testLoadData_withNetworkError_shouldTransitionToErrorState() async {
        // Given
        mockGetDetailUseCase.result = .failure(DomainError.networkUnavailable)
        
        let expectation = XCTestExpectation(description: "State should become error")
        
        sut.$state
            .dropFirst()
            .sink { state in
                if case .error(let error) = state {
                    XCTAssertEqual(error, .networkUnavailable)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.loadData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testLoadData_withNotFoundError_shouldShowNotFoundError() async {
        // Given
        mockGetDetailUseCase.result = .failure(DomainError.notFound)
        
        let expectation = XCTestExpectation(description: "State should become error")
        
        sut.$state
            .dropFirst()
            .sink { state in
                if case .error(let error) = state, case .notFound = error {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.loadData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    // MARK: - Retry
    
    func testRetry_shouldReloadData() async {
        // Given - First load fails
        mockGetDetailUseCase.result = .failure(DomainError.networkUnavailable)
        
        let errorExpectation = XCTestExpectation(description: "Error state")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .error = state { errorExpectation.fulfill() }
            }
            .store(in: &cancellables)
        
        sut.loadData()
        await fulfillment(of: [errorExpectation], timeout: 2.0)
        
        // When - Retry succeeds
        mockGetDetailUseCase.result = .success(TestData.sampleDealOnSale)
        
        let successExpectation = XCTestExpectation(description: "Success state")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state { successExpectation.fulfill() }
            }
            .store(in: &cancellables)
        
        sut.retry()
        
        // Then
        await fulfillment(of: [successExpectation], timeout: 2.0)
        XCTAssertEqual(mockGetDetailUseCase.executeCallCount, 2)
    }
    
    // MARK: - Cart Operations
    
    func testAddToCart_shouldSetQuantityAndShowAlert() {
        // When
        sut.addToCart()
        
        // Then
        XCTAssertEqual(sut.quantity, 1)
        XCTAssertTrue(sut.isInCart)
        XCTAssertTrue(sut.showAddedToCartAlert)
    }
    
    func testIncrementQuantity_shouldRespectMaximumLimit() {
        // Given
        sut.addToCart()
        
        // When - increment to maximum (10)
        for _ in 1..<15 {
            sut.incrementQuantity()
        }
        
        // Then - should cap at 10
        XCTAssertEqual(sut.quantity, 10)
        XCTAssertFalse(sut.canIncrement)
    }
    
    func testDecrementQuantity_shouldRespectMinimumLimit() {
        // Given
        sut.addToCart()
        
        // When - try to decrement below 0
        sut.decrementQuantity()
        sut.decrementQuantity()
        
        // Then - should stop at 0
        XCTAssertEqual(sut.quantity, 0)
        XCTAssertFalse(sut.canDecrement)
        XCTAssertFalse(sut.isInCart)
    }
    
    func testRemoveFromCart_shouldResetQuantity() {
        // Given
        sut.addToCart()
        sut.incrementQuantity()
        XCTAssertEqual(sut.quantity, 2)
        
        // When
        sut.removeFromCart()
        
        // Then
        XCTAssertEqual(sut.quantity, 0)
        XCTAssertFalse(sut.isInCart)
    }
}
