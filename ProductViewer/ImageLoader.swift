//
//  ImageLoader.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit


protocol ImageLoaderProtocol: AnyObject {
    func loadImage(from url: URL) async throws -> UIImage
}


final class ImageLoader: ImageLoaderProtocol {
    
    
    private let loadImageUseCase: LoadImageUseCaseProtocol
    
    init(loadImageUseCase: LoadImageUseCaseProtocol) {
        self.loadImageUseCase = loadImageUseCase
    }
    
    
    func loadImage(from url: URL) async throws -> UIImage {
        let data = try await loadImageUseCase.execute(url: url)
        
        guard let image = UIImage(data: data) else {
            throw DomainError.invalidData
        }
        
        return image
    }
    
}

