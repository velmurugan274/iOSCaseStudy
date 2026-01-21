//
//  NetworkService.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation


protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func fetchData(from url: URL) async throws -> Data
}


final class NetworkService : NetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            logger.log("Invalid URL for endpoint")
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.log("Invalid response type")
                throw NetworkError.networkError("Invalid response type")
            }
            
            logger.log("Response: \(httpResponse.statusCode) for \(url.lastPathComponent)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                logger.log("Server error: \(httpResponse.statusCode)")
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch let decodingError {
                logger.log("Decoding error: \(decodingError.localizedDescription)")
                throw NetworkError.decodingError(decodingError.localizedDescription)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            logger.log("Network error: \(error.localizedDescription)")
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
    
    func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError("Invalid response type")
            }
            
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
}

