//
//  MockUseCases.swift
//  ProductViewerTests
//
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation
@testable import ProductViewer

// MARK: - Mock FetchDealsUseCase

final class MockFetchDealsUseCase: FetchDealsUseCaseProtocol {
    var result: Result<[DealEntity], Error> = .success([])
    var executeCallCount = 0
    
    func execute() async throws -> [DealEntity] {
        executeCallCount += 1
        switch result {
        case .success(let deals):
            return deals
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Mock GetDealDetailUseCase

final class MockGetDealDetailUseCase: GetDealDetailUseCaseProtocol {
    var result: Result<DealEntity, Error> = .success(TestData.sampleDeal)
    var executeCallCount = 0
    var lastRequestedId: Int?
    
    func execute(id: Int) async throws -> DealEntity {
        executeCallCount += 1
        lastRequestedId = id
        switch result {
        case .success(let deal):
            return deal
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Mock Delegate

@MainActor
final class MockDealListViewModelDelegate: DealListViewModelDelegate {
    var selectedDeal: DealEntity?
    var didSelectDealCallCount = 0
    
    func dealListViewModel(_ viewModel: DealListViewModelProtocol, didSelectDeal deal: DealEntity) {
        didSelectDealCallCount += 1
        selectedDeal = deal
    }
}


