//
//  LoadImageUseCase.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation

public protocol LoadImageUseCaseProtocol {
    func execute(url: URL) async throws -> Data
}

public final class LoadImageUseCase: LoadImageUseCaseProtocol {
    
    
    private let repository: DealsRepositoryInterface
    private let cache: ImageCache?
    
    
   init(repository: DealsRepositoryInterface,
        cache: ImageCache? = nil) {
        self.repository = repository
        self.cache = cache
    }
    
    public func execute(url: URL) async throws -> Data {
        let cacheKey = url.absoluteString
        
        if let cachedData = cache?.getImage(for: cacheKey) {
            return cachedData
        }
        
        let imageData = try await repository.fetchImageData(from: url)
        cache?.setImage(imageData, for: cacheKey)
        
        return imageData
    }
}



