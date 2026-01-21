//
//  DealListViewController.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//
import SwiftUI
import Combine
import UIKit

final class DealListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewLayoutFactory.createAdaptiveDealListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(DealListCell.self, forCellWithReuseIdentifier: DealListCell.reuseIdentifier)
        collectionView.accessibilityIdentifier = AccessibilityIdentifiers.DealList.collectionView
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        control.tintColor = listTheme.primaryColor
        return control
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = listTheme.primaryColor
        indicator.accessibilityIdentifier = AccessibilityIdentifiers.DealList.loadingIndicator
        return indicator
    }()
    
    private lazy var stateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var navBarActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = listTheme.primaryColor
        return indicator
    }()
    
    private var contentUnavailableHostingController: UIViewController?
    
    private enum Section { case main }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, DealEntity> = {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, deal in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DealListCell.reuseIdentifier,
                    for: indexPath
                  ) as? DealListCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: deal, imageLoader: self.imageLoader, theme: self.listTheme)
            return cell
        }
    }()
    
    private let viewModel: DealListViewModelProtocol
    private let imageLoader: ImageLoaderProtocol
    private let listTheme: ListViewThemeable
    private let baseTheme: Theme
    

    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DealListViewModelProtocol, imageLoader: ImageLoaderProtocol, listTheme: ListViewThemeable = ListViewTheme(),
        baseTheme: Theme = ThemeManager.shared.currentTheme) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.listTheme = listTheme
        self.baseTheme = baseTheme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.removeAll()
        contentUnavailableHostingController?.willMove(toParent: nil)
        contentUnavailableHostingController?.view.removeFromSuperview()
        contentUnavailableHostingController?.removeFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
}

// MARK: - UICollectionViewDelegate
extension DealListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectDeal(at: indexPath.item)
    }
}


// MARK: - Helper Methods
extension DealListViewController {
    
    private func setupUI() {
        view.backgroundColor = listTheme.cellBackgroundColor
        
        view.addSubview(collectionView)
        view.addSubview(stateContainerView)
        view.addSubview(activityIndicator)
        
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = listTheme.cellBackgroundColor
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stateContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigation() {
        navigationItem.backButtonDisplayMode = .minimal
        setupTitleViewWithIndicator()
    }
    
    private func setupTitleViewWithIndicator() {
        let titleLabel = UILabel()
        titleLabel.text = Strings.Navigation.dealsTitle
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .label
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, navBarActivityIndicator])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        navigationItem.titleView = stackView
    }
    
    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: DealListViewState) {
        endRefreshIfNeeded()

        switch state {
        case .idle:
            break

        case .loading:
            showLoading()

        case .refreshing:
            handleRefreshingState()

        case .loaded(let deals):
            showDeals(deals)

        case .empty:
            showEmpty()

        case .error(let message):
            showError(message)

        case .networkError:
            showNetworkError()
        }
    }

    
    private func showLoading() {
        hideStateView()
        navBarActivityIndicator.stopAnimating()
        activityIndicator.startAnimating()
        activityIndicator.accessibilityLabel = Strings.DealList.loading
    }
    
    private func showRefreshing() {
        navBarActivityIndicator.startAnimating()
    }
    
    private func showDeals(_ deals: [DealEntity]) {
        activityIndicator.stopAnimating()
        navBarActivityIndicator.stopAnimating()
        hideStateView()
        collectionView.isHidden = false
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, DealEntity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(deals)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func showError(_ message: String) {
        activityIndicator.stopAnimating()
        navBarActivityIndicator.stopAnimating()
        collectionView.isHidden = true
        
        showStateView(configuration: .notFound, retryAction: { [weak self] in
            self?.viewModel.refresh()
        })
    }
    
    private func showEmpty() {
        activityIndicator.stopAnimating()
        navBarActivityIndicator.stopAnimating()
        collectionView.isHidden = true
        
        showStateView(configuration: .emptyDeals, retryAction: { [weak self] in
            self?.viewModel.refresh()
        })
    }
    
    private func showNetworkError() {
        activityIndicator.stopAnimating()
        navBarActivityIndicator.stopAnimating()
        collectionView.isHidden = true
        
        showStateView(configuration: .networkError, retryAction: { [weak self] in
            self?.viewModel.refresh()
        })
    }
    
    private func showStateView(configuration: ContentUnavailableConfiguration, retryAction: @escaping () -> Void) {
        contentUnavailableHostingController?.willMove(toParent: nil)
        contentUnavailableHostingController?.view.removeFromSuperview()
        contentUnavailableHostingController?.removeFromParent()
        contentUnavailableHostingController = nil
        
        let contentView = ContentUnavailableWrapper(configuration: configuration, action: retryAction)
        
        let hostingController = UIHostingController(rootView: AnyView(contentView))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        stateContainerView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: stateContainerView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: stateContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: stateContainerView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: stateContainerView.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        contentUnavailableHostingController = hostingController
        
        stateContainerView.isHidden = false
    }
    
    private func hideStateView() {
        stateContainerView.isHidden = true
        contentUnavailableHostingController?.willMove(toParent: nil)
        contentUnavailableHostingController?.view.removeFromSuperview()
        contentUnavailableHostingController?.removeFromParent()
        contentUnavailableHostingController = nil
    }
    

    @objc private func handleRefresh() {
        viewModel.refresh()
    }
    
    private func endRefreshIfNeeded() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }

    private func handleRefreshingState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self, case .refreshing = self.viewModel.state else { return }

            self.showRefreshing()
        }
    }

}
