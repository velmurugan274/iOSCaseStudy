//
//  DealsAssembler.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

final class DealsAssembler {
    
    static let shared = DealsAssembler()
    
    private let themeManager: ThemeManagerProtocol
    private let networkService: NetworkServiceProtocol
    private let imageCache: ImageCache
    
    var theme: Theme {
        themeManager.currentTheme
    }
    
    private lazy var dealsRepository: DealsRepositoryInterface = {
        DataManager(networkService: networkService)
    }()
    
    init(themeManager: ThemeManagerProtocol = ThemeManager.shared, networkService: NetworkServiceProtocol = NetworkService(),
        imageCache: ImageCache = ImageCache.shared) {
        self.themeManager = themeManager
        self.networkService = networkService
        self.imageCache = imageCache
    }
    
    func makeFetchDealsUseCase() -> FetchDealsUseCaseProtocol {
        FetchDealsUseCase(repository: dealsRepository)
    }
    
    func makeGetDealDetailUseCase() -> GetDealDetailUseCaseProtocol {
        GetDealDetailUseCase(repository: dealsRepository)
    }
    
    func makeLoadImageUseCase() -> LoadImageUseCaseProtocol {
        LoadImageUseCase(repository: dealsRepository, cache: imageCache)
    }
    
    @MainActor
    func makeDealListViewModel() -> DealListViewModel {
        DealListViewModel(fetchDealsUseCase: makeFetchDealsUseCase())
    }
    
    @MainActor
    func makeDealDetailViewModel(deal: DealEntity) -> DealDetailViewModel {
        DealDetailViewModel(deal: deal, getDealDetailUseCase: makeGetDealDetailUseCase())
    }
    
    
    func makeListViewTheme() -> ListViewThemeable {
        themeManager.makeListViewTheme()
    }
    
    func makeDetailViewTheme() -> DetailViewThemeable {
        themeManager.makeDetailViewTheme()
    }
    
    func makeNavigationTheme() -> NavigationThemeable {
        themeManager.makeNavigationTheme()
    }
}

