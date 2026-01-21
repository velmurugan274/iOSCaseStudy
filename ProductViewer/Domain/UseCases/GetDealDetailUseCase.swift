//
//  GetDealDetailUseCase.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation

public protocol GetDealDetailUseCaseProtocol {
    func execute(id: Int) async throws -> DealEntity
}

public final class GetDealDetailUseCase: GetDealDetailUseCaseProtocol {
    
    
    private let repository: DealsRepositoryInterface
    

    public init(repository: DealsRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(id: Int) async throws -> DealEntity {
        let deal = try await repository.fetchDealDetail(id: id)
        return deal
    }
    
}



