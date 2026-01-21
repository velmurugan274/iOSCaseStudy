//
//  AppCoordinator.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let window: UIWindow
    private let themeManager: ThemeManagerProtocol
    private let assembler: DealsAssembler
    
    private var cancellables = Set<AnyCancellable>()
    
    init(window: UIWindow, themeManager: ThemeManagerProtocol = ThemeManager.shared,
         assembler: DealsAssembler = .shared) {
        self.window = window
        self.themeManager = themeManager
        self.assembler = assembler
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let navigationTheme = themeManager.makeNavigationTheme()
        applyNavigationTheme(navigationTheme)
        
        themeManager.themePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let updatedTheme = self.themeManager.makeNavigationTheme()
                self.applyNavigationTheme(updatedTheme)
            }
            .store(in: &cancellables)
        
        startDealsCoordinator()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}

// MARK: - Helper Methods
extension AppCoordinator {
    
    private func startDealsCoordinator(){
        let dealsCoordinator = DealsCoordinator(navigationController: navigationController, assembler: assembler,
            themeManager: themeManager)
        addChild(dealsCoordinator)
        dealsCoordinator.start()
    }
    
    private func applyNavigationTheme(_ theme: NavigationThemeable) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        let navigationImage = UIImage(systemName: "arrow.backward")
        appearance.setBackIndicatorImage(navigationImage, transitionMaskImage: navigationImage)
        navigationController.navigationBar.tintColor = theme.barTintColor
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
    }
}
