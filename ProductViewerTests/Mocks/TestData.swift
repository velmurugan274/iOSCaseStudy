//
//  TestData.swift
//  ProductViewerTests
//
//  Copyright © 2026 Target. All rights reserved.
//

import Foundation
@testable import ProductViewer

enum TestData {
    
    static let samplePrice = PriceEntity(
        amountInCents: 1999,
        currencySymbol: "$",
        displayString: "$19.99"
    )
    
    static let sampleSalePrice = PriceEntity(
        amountInCents: 1499,
        currencySymbol: "$",
        displayString: "$14.99"
    )
    
    static let sampleDeal = DealEntity(
        id: 1,
        title: "Sample Product",
        aisle: "A1",
        description: "This is a sample product description",
        imageUrl: URL(string: "https://example.com/image.jpg"),
        regularPrice: samplePrice,
        salePrice: nil,
        fulfillment: "Online",
        availability: "In Stock"
    )
    
    static let sampleDealOnSale = DealEntity(
        id: 2,
        title: "Sale Product",
        aisle: "B2",
        description: "This product is on sale",
        imageUrl: URL(string: "https://example.com/image2.jpg"),
        regularPrice: samplePrice,
        salePrice: sampleSalePrice,
        fulfillment: "In Store",
        availability: "Limited Stock"
    )
    
    static let sampleDealsList: [DealEntity] = [
        sampleDeal,
        sampleDealOnSale
    ]
}


