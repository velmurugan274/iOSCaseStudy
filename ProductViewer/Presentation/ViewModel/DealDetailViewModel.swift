//
//  DealDetailViewModel.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import Combine

enum DealDetailViewState: Equatable {
    case idle
    case loading
    case loaded(DealEntity)
    case error(DealDetailError)
    
    enum DealDetailError: Equatable {
        case notFound(message: String)
        case networkUnavailable
        case generic(message: String)
        
        var title: String {
            switch self {
            case .notFound:
                return "Product Unavailable"
            case .networkUnavailable:
                return "No Connection"
            case .generic:
                return "Something Went Wrong"
            }
        }
        
        var message: String {
            switch self {
            case .notFound(let message):
                return message
            case .networkUnavailable:
                return "Please check your internet connection and try again."
            case .generic(let message):
                return message
            }
        }
        
        var systemImage: String {
            switch self {
            case .notFound:
                return "tag.slash"
            case .networkUnavailable:
                return "wifi.slash"
            case .generic:
                return "exclamationmark.triangle"
            }
        }
        
        var canRetry: Bool {
            switch self {
            case .notFound:
                return false  // Product doesn't exist, no point retrying
            case .networkUnavailable, .generic:
                return true
            }
        }
    }
}


@MainActor
final class DealDetailViewModel: ObservableObject {
    
    @Published var state: DealDetailViewState = .idle
    @Published var deal: DealEntity
    @Published var quantity: Int = 0
    
    private let getDealDetailUseCase: GetDealDetailUseCaseProtocol
    private var currentTask: Task<Void, Never>?
    
    var isInCart: Bool {
        quantity > 0
    }
    
    var canDecrement: Bool {
        quantity > 0
    }
    
    var canIncrement: Bool {
        quantity < 10
    }
    
    init(deal: DealEntity, getDealDetailUseCase: GetDealDetailUseCaseProtocol) {
        self.deal = deal
        self.getDealDetailUseCase = getDealDetailUseCase
    }
    
    deinit {
        currentTask?.cancel()
    }
    
    func retry() {
        loadData()
    }
    
    func loadData() {
        currentTask?.cancel()
        
        state = .loading
        
        currentTask = Task {
            do {
                let detailedDeal = try await getDealDetailUseCase.execute(id: deal.id)
                
                guard !Task.isCancelled else { return }
                
                self.deal = detailedDeal
                self.state = .loaded(detailedDeal)
            } catch {
                guard !Task.isCancelled else { return }
                self.state = .error(mapError(error))
            }
        }
    }
    
    func addToCart() {
        quantity = 1
    }
    
    func incrementQuantity() {
        guard canIncrement else { return }
        quantity += 1
    }
    
    func decrementQuantity() {
        guard canDecrement else { return }
        quantity -= 1
    }
    
    func removeFromCart() {
        quantity = 0
    }
    
    private func mapError(_ error: Error) -> DealDetailViewState.DealDetailError {
        if let domainError = error as? DomainError {
            switch domainError {
            case .notFound:
                return .notFound(message: "This product is no longer available.")
            case .networkUnavailable:
                return .networkUnavailable
            case .invalidData:
                return .generic(message: "Unable to load product details.")
            case .unknown(let message):
                return .generic(message: message)
            }
        }
        return .generic(message: error.localizedDescription)
    }
}
