//
//  ProductViewerTests.swift
//  ProductViewerTests
//
//  Copyright © 2022 Target. All rights reserved.
//

import XCTest
@testable import ProductViewer

// MARK: - DealEntity Tests

final class DealEntityTests: XCTestCase {
    
    func testCurrentPrice_withSalePrice_shouldReturnSalePrice() {
        let deal = TestData.sampleDealOnSale
        XCTAssertEqual(deal.currentPrice, TestData.sampleSalePrice)
    }
    
    func testCurrentPrice_withoutSalePrice_shouldReturnRegularPrice() {
        let deal = TestData.sampleDeal
        XCTAssertEqual(deal.currentPrice, TestData.samplePrice)
    }
    
    func testIsOnSale_shouldReturnCorrectValue() {
        XCTAssertTrue(TestData.sampleDealOnSale.isOnSale)
        XCTAssertFalse(TestData.sampleDeal.isOnSale)
    }
    
    func testDiscountPercentage_shouldCalculateCorrectly() {
        // Regular: 1999 cents, Sale: 1499 cents = 25% off
        XCTAssertEqual(TestData.sampleDealOnSale.discountPercentage, 25)
        XCTAssertNil(TestData.sampleDeal.discountPercentage)
    }
    
    func testIsAvailable_shouldReturnCorrectValue() {
        XCTAssertTrue(TestData.sampleDeal.isAvailable) // "In Stock"
        XCTAssertTrue(TestData.sampleDealOnSale.isAvailable) // "Limited Stock"
    }
}

// MARK: - PriceEntity Tests

final class PriceEntityTests: XCTestCase {
    
    func testAmount_shouldConvertCentsToDecimal() {
        let price = PriceEntity(amountInCents: 1999, currencySymbol: "$", displayString: "$19.99")
        XCTAssertEqual(price.amount, Decimal(19.99))
    }
}
