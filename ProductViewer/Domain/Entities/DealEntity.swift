//
//  DealEntity.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

//
//  DealEntity.swift
//  ProductViewer
//
//  Domain Layer - Entity with Codable support
//  Copyright © 2024 Target. All rights reserved.
//

import Foundation

struct DealsResponse: Decodable {
    let products: [DealEntity]
}

public struct DealEntity: Equatable, Hashable, Identifiable, Codable {
    public let id: Int
    public let title: String
    public let aisle: String
    public let description: String
    public let imageUrl: URL?
    public let regularPrice: PriceEntity
    public let salePrice: PriceEntity?
    public let fulfillment: String
    public let availability: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case aisle
        case description
        case imageUrl = "image_url"
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case fulfillment
        case availability
    }
    
    public init(id: Int, title: String, aisle: String,
        description: String, imageUrl: URL?, regularPrice: PriceEntity,
        salePrice: PriceEntity?, fulfillment: String, availability: String) {
        self.id = id
        self.title = title
        self.aisle = aisle
        self.description = description
        self.imageUrl = imageUrl
        self.regularPrice = regularPrice
        self.salePrice = salePrice
        self.fulfillment = fulfillment
        self.availability = availability
    }
}

public struct PriceEntity: Equatable, Hashable, Codable {
    public let amountInCents: Int
    public let currencySymbol: String
    public let displayString: String
    
    private enum CodingKeys: String, CodingKey {
        case amountInCents = "amount_in_cents"
        case currencySymbol = "currency_symbol"
        case displayString = "display_string"
    }
    
    public init(amountInCents: Int, currencySymbol: String, displayString: String) {
        self.amountInCents = amountInCents
        self.currencySymbol = currencySymbol
        self.displayString = displayString
    }
    
    public var amount: Decimal {
        Decimal(amountInCents) / 100
    }
}

public enum FulfillmentType: String {
    case online = "Online"
    case inStore = "In Store"
    case unknown
    
    public init(rawString: String) {
        self = FulfillmentType(rawValue: rawString) ?? .unknown
    }
}

public enum AvailabilityStatus {
    case inStock
    case limitedStock
    case outOfStock
    case unknown
    
    public init(rawString: String) {
        switch rawString.lowercased() {
        case "in stock", "instock":
            self = .inStock
        case "limited stock", "limitedstock":
            self = .limitedStock
        case "out of stock", "outofstock":
            self = .outOfStock
        default:
            self = .unknown
        }
    }
}

// MARK: - Business Logic Extensions

extension DealEntity {
    
    public var fulfillmentType: FulfillmentType {
        FulfillmentType(rawString: fulfillment)
    }
    
    public var availabilityStatus: AvailabilityStatus {
        AvailabilityStatus(rawString: availability)
    }
    
    public var currentPrice: PriceEntity {
        salePrice ?? regularPrice
    }
    
    public var isOnSale: Bool {
        salePrice != nil
    }
    
    public var discountPercentage: Int? {
        guard let sale = salePrice else { return nil }
        let discount = regularPrice.amountInCents - sale.amountInCents
        let percentage = (Double(discount) / Double(regularPrice.amountInCents)) * 100
        return Int(percentage.rounded())
    }
    
    public var isAvailable: Bool {
        availabilityStatus == .inStock || availabilityStatus == .limitedStock
    }
    
    public var savingsInCents: Int? {
        guard let sale = salePrice else { return nil }
        return regularPrice.amountInCents - sale.amountInCents
    }
}
