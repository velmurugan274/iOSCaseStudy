//
//  ImageCache.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//


import Foundation

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache: NSCache<NSString, NSData>
    
    init(countLimit: Int = 50, totalCostLimit: Int = 50 * 1024 * 1024) {
        self.cache = NSCache<NSString, NSData>()
        self.cache.countLimit = countLimit
        self.cache.totalCostLimit = totalCostLimit
    }
    
    func getImage(for key: String) -> Data? {
        let nsKey = key as NSString
        if let data = cache.object(forKey: nsKey) as Data? {
            logger.log("Cache hit for: \(key)")
            return data
        }
        logger.log("Cache miss for: \(key)")
        return nil
    }
    
    func setImage(_ data: Data, for key: String) {
        let nsKey = key as NSString
        let nsData = data as NSData
        cache.setObject(nsData, forKey: nsKey, cost: data.count)
        logger.log("Cached image: \(key) (\(data.count) bytes)")
    }
    
    func removeImage(for key: String) {
        let nsKey = key as NSString
        cache.removeObject(forKey: nsKey)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}


