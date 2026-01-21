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
    
    private var vm: DealDetailViewModel!
    private var mockGetDetailUseCase: MockGetDealDetailUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockGetDetailUseCase = MockGetDealDetailUseCase()
        vm = DealDetailViewModel(
            deal: TestData.sampleDeal,
            getDealDetailUseCase: mockGetDetailUseCase
        )
        cancellables = []
    }
    
    override func tearDown() {
        vm = nil
        mockGetDetailUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State
    
    func testInitialState_shouldHaveCorrectDefaults() {
        XCTAssertEqual(vm.state, .idle)
        XCTAssertEqual(vm.deal, TestData.sampleDeal)
        XCTAssertEqual(vm.quantity, 0)
        XCTAssertFalse(vm.isInCart)
    }
    
    // MARK: - Load Data
    
    func testLoadData_onSuccess_shouldUpdateStateAndDeal() async {
        // Given
        let detailedDeal = TestData.sampleDealOnSale
        mockGetDetailUseCase.result = .success(detailedDeal)
        
        let expectation = XCTestExpectation(description: "State should become loaded")
        
        vm.$state
            .dropFirst()
            .sink { state in
                if case .loaded(let deal) = state {
                    XCTAssertEqual(deal, detailedDeal)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        vm.loadData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(vm.deal, detailedDeal)
        XCTAssertEqual(mockGetDetailUseCase.lastRequestedId, TestData.sampleDeal.id)
    }
    
    func testLoadData_withNetworkError_shouldTransitionToErrorState() async {
        // Given
        mockGetDetailUseCase.result = .failure(DomainError.networkUnavailable)
        
        let expectation = XCTestExpectation(description: "State should become error")
        
        vm.$state
            .dropFirst()
            .sink { state in
                if case .error(let error) = state {
                    XCTAssertEqual(error, .networkUnavailable)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        vm.loadData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testLoadData_withNotFoundError_shouldShowNotFoundError() async {
        // Given
        mockGetDetailUseCase.result = .failure(DomainError.notFound)
        
        let expectation = XCTestExpectation(description: "State should become error")
        
        vm.$state
            .dropFirst()
            .sink { state in
                if case .error(let error) = state, case .notFound = error {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        vm.loadData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    // MARK: - Retry
    
    func testRetry_shouldReloadData() async {
        // Given - First load fails
        mockGetDetailUseCase.result = .failure(DomainError.networkUnavailable)
        
        let errorExpectation = XCTestExpectation(description: "Error state")
        vm.$state
            .dropFirst()
            .sink { state in
                if case .error = state { errorExpectation.fulfill() }
            }
            .store(in: &cancellables)
        
        vm.loadData()
        await fulfillment(of: [errorExpectation], timeout: 2.0)
        
        // When - Retry succeeds
        mockGetDetailUseCase.result = .success(TestData.sampleDealOnSale)
        
        let successExpectation = XCTestExpectation(description: "Success state")
        vm.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state { successExpectation.fulfill() }
            }
            .store(in: &cancellables)
        
        vm.retry()
        
        // Then
        await fulfillment(of: [successExpectation], timeout: 2.0)
        XCTAssertEqual(mockGetDetailUseCase.executeCallCount, 2)
    }
    
    // MARK: - Cart Operations
    
    func testAddToCart_shouldSetQuantityAndShowAlert() {
        // When
        vm.addToCart()
        
        // Then
        XCTAssertEqual(vm.quantity, 1)
        XCTAssertTrue(vm.isInCart)
    }
    
    func testIncrementQuantity_shouldRespectMaximumLimit() {
        // Given
        vm.addToCart()
        
        // When - increment to maximum (10)
        for _ in 1..<15 {
            vm.incrementQuantity()
        }
        
        // Then - should cap at 10
        XCTAssertEqual(vm.quantity, 10)
        XCTAssertFalse(vm.canIncrement)
    }
    
    func testDecrementQuantity_shouldRespectMinimumLimit() {
        // Given
        vm.addToCart()
        
        // When - try to decrement below 0
        vm.decrementQuantity()
        vm.decrementQuantity()
        
        // Then - should stop at 0
        XCTAssertEqual(vm.quantity, 0)
        XCTAssertFalse(vm.canDecrement)
        XCTAssertFalse(vm.isInCart)
    }
    
    func testRemoveFromCart_shouldResetQuantity() {
        // Given
        vm.addToCart()
        vm.incrementQuantity()
        XCTAssertEqual(vm.quantity, 2)
        
        // When
        vm.removeFromCart()
        
        // Then
        XCTAssertEqual(vm.quantity, 0)
        XCTAssertFalse(vm.isInCart)
    }
}
