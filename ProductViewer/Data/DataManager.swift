//
//  DataManager.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation

final class DataManager : DealsRepositoryInterface {
    

    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchDeals() async throws -> [DealEntity] {
        do {
            let response: DealsResponse = try await networkService.fetch(.deals)
            return response.products
        } catch {
            throw ErrorMapper.mapToDomain(error)
        }
    }
    
    func fetchDealDetail(id: Int) async throws -> DealEntity {
        do {
            let deal: DealEntity = try await networkService.fetch(.dealDetail(id: id))
            return deal
        } catch {
            throw ErrorMapper.mapToDomain(error)
        }
    }
    
    func fetchImageData(from url: URL) async throws -> Data {
        do {
            return try await networkService.fetchData(from: url)
        } catch {
            throw ErrorMapper.mapToDomain(error)
        }
    }
}


