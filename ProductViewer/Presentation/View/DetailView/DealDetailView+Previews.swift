//
//  DealDetailView+Previews.swift
//  ProductViewer
//
//  Created by Velmurugan on 20/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import SwiftUI

// MARK: - Previews

#Preview("In Stock") {
    DealDetailView(viewModel: PreviewViewModelFactory.inStock())
}

#Preview("Out of Stock") {
    DealDetailView(viewModel: PreviewViewModelFactory.outOfStock())
}

#Preview("Loading") {
    DealDetailView(viewModel: PreviewViewModelFactory.loading())
}

#Preview("Not Found Error") {
    DealDetailView(viewModel: PreviewViewModelFactory.notFoundError())
}

#Preview("Network Error") {
    DealDetailView(viewModel: PreviewViewModelFactory.networkError())
}

// MARK: - Preview Helpers

@MainActor
private enum PreviewViewModelFactory {
    
    static func inStock() -> DealDetailViewModel {
        let vm = DealDetailViewModel(
            deal: .previewInStock,
            getDealDetailUseCase: PreviewGetDealDetailUseCase(deal: .previewInStock)
        )
        vm.state = .loaded(.previewInStock)
        return vm
    }
    
    
    static func outOfStock() -> DealDetailViewModel {
        let vm = DealDetailViewModel(
            deal: .previewOutOfStock,
            getDealDetailUseCase: PreviewGetDealDetailUseCase(deal: .previewOutOfStock)
        )
        vm.state = .loaded(.previewOutOfStock)
        return vm
    }

    static func loading() -> DealDetailViewModel {
        let vm = DealDetailViewModel(
            deal: .previewInStock,
            getDealDetailUseCase: PreviewGetDealDetailUseCase(deal: .previewInStock, delay: .infinity)
        )
        vm.state = .loading
        return vm
    }
    
    static func notFoundError() -> DealDetailViewModel {
        let vm = DealDetailViewModel(
            deal: .previewInStock,
            getDealDetailUseCase: PreviewGetDealDetailUseCase(error: .notFound)
        )
        vm.state = .error(.notFound(message: "This product is no longer available."))
        return vm
    }
    
    static func networkError() -> DealDetailViewModel {
        let vm = DealDetailViewModel(
            deal: .previewInStock,
            getDealDetailUseCase: PreviewGetDealDetailUseCase(error: .networkUnavailable)
        )
        vm.state = .error(.networkUnavailable)
        return vm
    }
    
}

private extension DealEntity {
    
    static let previewInStock = DealEntity(
        id: 1,
        title: "Women's Slim Fit Ribbed High Neck Sweater",
        aisle: "D45",
        description: "A versatile wardrobe essential perfect for layering or wearing on its own. This slim fit ribbed high neck sweater features soft, stretchy fabric that moves with you. The classic silhouette pairs beautifully with jeans, skirts, or dress pants.",
        imageUrl: URL(string: "https://picsum.photos/400"),
        regularPrice: PriceEntity(
            amountInCents: 2499,
            currencySymbol: "$",
            displayString: "$24.99"
        ),
        salePrice: nil,
        fulfillment: "Online",
        availability: "In Stock"
    )
    
    static let previewOutOfStock = DealEntity(
        id: 3,
        title: "Wireless Bluetooth Earbuds Pro",
        aisle: "E23",
        description: "Experience crystal-clear audio with active noise cancellation. These premium earbuds offer up to 8 hours of battery life and come with a wireless charging case.",
        imageUrl: URL(string: "https://picsum.photos/402"),
        regularPrice: PriceEntity(
            amountInCents: 12999,
            currencySymbol: "$",
            displayString: "$129.99"
        ),
        salePrice: PriceEntity(
            amountInCents: 9999,
            currencySymbol: "$",
            displayString: "$99.99"
        ),
        fulfillment: "Online",
        availability: "Out of Stock"
    )
}

private final class PreviewGetDealDetailUseCase: GetDealDetailUseCaseProtocol {
    
    enum PreviewError: Error {
        case notFound
        case networkUnavailable
        case generic
    }
    
    private let deal: DealEntity?
    private let error: DomainError?
    private let delay: TimeInterval
    
    init(deal: DealEntity? = nil, delay: TimeInterval = 0) {
        self.deal = deal
        self.error = nil
        self.delay = delay
    }
    
    init(error: DomainError) {
        self.deal = nil
        self.error = error
        self.delay = 0
    }
    
    func execute(id: Int) async throws -> DealEntity {
        if delay > 0 && delay != .infinity {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        } else if delay == .infinity {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
        
        if let error {
            throw error
        }
        
        return deal ?? .previewInStock
    }
}



