//
//  DealListViewModel.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//


import Foundation
import Combine

enum DealListViewState: Equatable {
    case idle
    case loading
    case refreshing
    case loaded([DealEntity])
    case networkError
    case error(String)
    case empty
}

@MainActor
protocol DealListViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<DealListViewState, Never> { get }
    var state: DealListViewState { get }
    
    func viewDidLoad()
    func refresh()
    func didSelectDeal(at index: Int)
}

@MainActor
protocol DealListViewModelDelegate: AnyObject {
    func dealListViewModel(_ viewModel: DealListViewModelProtocol, didSelectDeal deal: DealEntity)
}

final class DealListViewModel: DealListViewModelProtocol {
    
    @Published private(set) var state: DealListViewState = .idle
    
    var statePublisher: AnyPublisher<DealListViewState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    weak var delegate: DealListViewModelDelegate?
    
    private let fetchDealsUseCase: FetchDealsUseCaseProtocol
    private var deals: [DealEntity] = []
    private var currentTask: Task<Void, Never>?
    
    init(fetchDealsUseCase: FetchDealsUseCaseProtocol) {
        self.fetchDealsUseCase = fetchDealsUseCase
    }
    
    deinit {
        currentTask?.cancel()
    }
    
    func viewDidLoad() {
        loadDeals()
    }
    
    func refresh() {
        loadDeals()
    }
    
    func didSelectDeal(at index: Int) {
        guard index >= 0 && index < deals.count else { return }
        let deal = deals[index]
        delegate?.dealListViewModel(self, didSelectDeal: deal)
    }
    
    private func loadDeals() {
        currentTask?.cancel()
        
        state = deals.isEmpty ? .loading : .refreshing
        logger.log("Loading deals...")
        
        currentTask = Task { @MainActor in
            do {
                let fetchedDeals = try await fetchDealsUseCase.execute()
                
                guard !Task.isCancelled else { return }
                
                self.deals = fetchedDeals
                
                if fetchedDeals.isEmpty {
                    logger.log("No deals found")
                    self.state = .empty
                } else {
                    logger.log("Loaded \(fetchedDeals.count) deals")
                    self.state = .loaded(fetchedDeals)
                }
            } catch {
                guard !Task.isCancelled else { return }
                
                logger.log("Failed to load deals: \(error.localizedDescription)")
                
                if let domainError = error as? DomainError {
                    switch domainError {
                        case .networkUnavailable:
                            self.state = .networkError
                        default:
                            self.state = .error(domainError.localizedDescription)
                    }
                } else {
                    self.state = .error("An unexpected error occurred. Please try again.")
                }
            }
        }
    }
}




