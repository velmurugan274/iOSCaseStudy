//
//  NetworkUtils.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//
import Foundation


enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError(String)
    case serverError(statusCode: Int)
    case networkError(String)
}

enum APIEndpoint {
    case deals
    case dealDetail(id: Int)
    
    private static let baseURL = "https://api.target.com/mobile_case_study_deals/v1"
    
    var url: URL? {
        switch self {
        case .deals:
            return URL(string: "\(Self.baseURL)/deals")
        case .dealDetail(let id):
            return URL(string: "\(Self.baseURL)/deals/\(id)")
        }
    }
}

enum ErrorMapper {
    
    static func mapToDomain(_ error: Error) -> DomainError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidURL:
                return .invalidData
            case .noData:
                return .notFound
            case .decodingError:
                return .invalidData
            case .serverError(let code):
                if code == 404 {
                    return .notFound
                }
            case .networkError(let message):
                return .networkUnavailable
            }
        }
        
        return .unknown(message: error.localizedDescription)
    }
}
