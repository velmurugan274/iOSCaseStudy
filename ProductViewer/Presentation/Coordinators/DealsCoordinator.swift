//
//  DealsCoordinator.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit
import SwiftUI

@MainActor
final class DealsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let assembler: DealsAssembler
    private let themeManager: ThemeManagerProtocol
    
    private lazy var imageLoader: ImageLoaderProtocol = {
        ImageLoader(loadImageUseCase: assembler.makeLoadImageUseCase())
    }()
    

    init(navigationController: UINavigationController, assembler: DealsAssembler = .shared,
        themeManager: ThemeManagerProtocol = ThemeManager.shared) {
        self.navigationController = navigationController
        self.assembler = assembler
        self.themeManager = themeManager
    }
    
    func start() {
        showDealsList()
    }
}

// MARK: - DealListViewModelDelegate
extension DealsCoordinator: DealListViewModelDelegate {
    
    func dealListViewModel(_ viewModel: DealListViewModelProtocol, didSelectDeal deal: DealEntity) {
        showDealDetail(for: deal)
    }
}

// MARK: - Helper Methods
extension DealsCoordinator {
    private func showDealsList() {
        let viewModel = assembler.makeDealListViewModel()
        viewModel.delegate = self
        let viewController = DealListViewController(viewModel: viewModel, imageLoader: imageLoader,
                    listTheme: themeManager.makeListViewTheme(), baseTheme: themeManager.currentTheme)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showDealDetail(for deal: DealEntity) {
        let viewModel = assembler.makeDealDetailViewModel(deal: deal)
        let hostingController = DealDetailHostingController(viewModel: viewModel, detailTheme: themeManager.makeDetailViewTheme(),
            baseTheme: themeManager.currentTheme)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
