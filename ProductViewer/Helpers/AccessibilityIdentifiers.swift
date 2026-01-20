//
//  AccessibilityIdentifiers.swift
//  ProductViewer
//
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation

enum AccessibilityIdentifiers {
    
    enum DealList {
        static let collectionView = "dealList.collectionView"
        static let loadingIndicator = "dealList.loadingIndicator"
        static let emptyStateView = "dealList.emptyState"
        static let errorStateView = "dealList.errorState"
        static let retryButton = "dealList.retryButton"
        
        static func cell(at index: Int) -> String {
            "dealList.cell.\(index)"
        }
    }
    
    enum DealDetail {
        static let scrollView = "dealDetail.scrollView"
        static let loadingView = "dealDetail.loading"
        static let errorView = "dealDetail.error"
        static let productTitle = "dealDetail.productTitle"
        static let productPrice = "dealDetail.productPrice"
        static let productDescription = "dealDetail.productDescription"
        static let addToCartButton = "dealDetail.addToCartButton"
        static let quantityLabel = "dealDetail.quantityLabel"
        static let incrementButton = "dealDetail.incrementButton"
        static let decrementButton = "dealDetail.decrementButton"
        static let retryButton = "dealDetail.retryButton"
    }
}


