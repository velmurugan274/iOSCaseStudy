//
//  Strings.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation

enum Strings {
    

    enum Navigation {
        static let dealsTitle = String(localized: "navigation.deals.title")
        static let detailTitle = String(localized: "navigation.detail.title")
        static let back = String(localized: "navigation.back")
    }

    enum DealList {
        static let emptyTitle = String(localized: "dealList.empty.title")
        static let emptyMessage = String(localized: "dealList.empty.message")
        static let emptyRefresh = String(localized: "dealList.empty.refresh")
        static let errorTitle = String(localized: "dealList.error.title")
        static let errorRetry = String(localized: "dealList.error.retry")
        static let loading = String(localized: "dealList.loading")
    }
    
    enum DealDetail {
        static let productDetailsHeader = String(localized: "dealDetail.productDetails.header")
        static let addToCart = String(localized: "dealDetail.addToCart")
        static let outOfStock = String(localized: "dealDetail.outOfStock")
        static let loading = String(localized: "dealDetail.loading")
        static let tryAgain = String(localized: "dealDetail.tryAgain")
        static let goBack = String(localized: "dealDetail.goBack")
        static let addedToCartTitle = String(localized: "dealDetail.addedToCart.title")
        static let addedToCartOk = String(localized: "dealDetail.addedToCart.ok")
        
        static func addedToCartMessage(_ productName: String) -> String {
            String(format: String(localized: "dealDetail.addedToCart.message"), productName)
        }
    }
    
    enum Price {
        static let regularPrefix = String(localized: "price.regular.prefix")
        static let saleLabel = String(localized: "price.sale.label")
        static let originalLabel = String(localized: "price.original.label")
        
        static func discount(_ percentage: Int) -> String {
            String(format: String(localized: "price.discount.format"), percentage)
        }
        
        static func savings(_ amount: Double) -> String {
            String(format: String(localized: "price.savings.format"), amount)
        }
    }
    
    enum Availability {
        static let inStock = String(localized: "availability.inStock")
        static let limitedStock = String(localized: "availability.limitedStock")
        static let outOfStock = String(localized: "availability.outOfStock")
        static let unknown = String(localized: "availability.unknown")
        
        static func inAisle(_ aisle: String) -> String {
            String(format: String(localized: "availability.inAisle"), aisle)
        }
    }
    
    enum Fulfillment {
        static let online = String(localized: "fulfillment.online")
        static let inStore = String(localized: "fulfillment.inStore")
        static let shipToStore = String(localized: "fulfillment.shipToStore")
        static let unknown = String(localized: "fulfillment.unknown")
    }
    
    enum Error {
        static let networkUnavailable = String(localized: "error.network.unavailable")
        static let notFound = String(localized: "error.notFound")
        static let notFoundTitle = String(localized: "error.notFound.title")
        static let invalidData = String(localized: "error.invalidData")
        static let unknown = String(localized: "error.unknown")
        
        static func server(_ message: String) -> String {
            String(format: String(localized: "error.server"), message)
        }
    }
}

