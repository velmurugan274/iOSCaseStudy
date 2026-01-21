//
//  DealEntity+Extension.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit

extension DealEntity {
    
    var displayPrice: String {
        currentPrice.displayString
    }
    
    var displayRegularPrice: String? {
        guard isOnSale else { return nil }
        return "\(Strings.Price.regularPrefix) \(regularPrice.displayString)"
    }
    
    func availabilityAttributedText(theme: ListViewThemeable) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let statusColor = availabilityStatus.textColor(theme: theme)
        let statusAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: statusColor,
            .font: theme.captionFont
        ]
        let statusText = NSAttributedString(string: availabilityText, attributes: statusAttributes)
        attributedString.append(statusText)
        
        if !aisle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && (availabilityStatus == .inStock || availabilityStatus == .limitedStock) {
            let aisleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: theme.captionColor,
                .font: theme.captionFont
            ]
            let aisleText = NSAttributedString(
                string: " \(Strings.Availability.inAisle(aisle))",
                attributes: aisleAttributes
            )
            attributedString.append(aisleText)
        }
        
        return attributedString
    }
    
    var availabilityText: String {
        switch availabilityStatus {
        case .inStock:
            return Strings.Availability.inStock
        case .limitedStock:
            return Strings.Availability.limitedStock
        case .outOfStock:
            return Strings.Availability.outOfStock
        case .unknown:
            return Strings.Availability.unknown
        }
    }
    
    var fulfillmentText: String {
        switch fulfillmentType {
        case .online:
            return Strings.Fulfillment.online
        case .inStore:
            return Strings.Fulfillment.inStore
        case .unknown:
            return Strings.Fulfillment.unknown
        }
    }
    
}

extension AvailabilityStatus {
    func textColor(theme: ListViewThemeable) -> UIColor {
        switch self {
        case .inStock:
            return theme.successColor
        case .limitedStock:
            return theme.warningColor
        case .outOfStock:
            return theme.errorColor
        case .unknown:
            return theme.captionColor
        }
    }
}
