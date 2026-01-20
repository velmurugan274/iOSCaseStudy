//
//  DataManagerInterface.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation

public enum DomainError: Error, Equatable {
    case notFound
    case networkUnavailable
    case invalidData
    case unknown(message: String)
    
    public var localizedDescription: String {
        switch self {
        case .notFound:
            return String(localized: "error.notFound")
        case .networkUnavailable:
            return String(localized: "error.network.unavailable")
        case .invalidData:
            return String(localized: "error.invalidData")
        case .unknown(let message):
            return message.isEmpty ? String(localized: "error.unknown") : message
        }
    }
}

public protocol DealsRepositoryInterface {
    func fetchDeals() async throws -> [DealEntity]
    func fetchDealDetail(id: Int) async throws -> DealEntity
    
    func fetchImageData(from url: URL) async throws -> Data
}


