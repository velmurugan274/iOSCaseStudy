//
//  FetchDealsUseCase.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation

public protocol FetchDealsUseCaseProtocol {
    func execute() async throws -> [DealEntity]
}

public final class FetchDealsUseCase: FetchDealsUseCaseProtocol {
    
    private let repository: DealsRepositoryInterface
    
    public init(repository: DealsRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute() async throws -> [DealEntity] {
        let deals = try await repository.fetchDeals()   
        // any extra business logic can be done here
        return deals
    }
}


