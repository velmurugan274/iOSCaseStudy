//
//  DealListCell.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit
import SwiftUI
import Combine


final class DealListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DealListCell"
    
    private var theme: ListViewThemeable = ThemeManager.shared.makeListViewTheme() {
        didSet {
            applyTheme()
        }
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let regularPriceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, regularPriceLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .lastBaseline
        return stack
    }()
    
    private let fulfillmentLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let availabilityLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            priceStackView,
            fulfillmentLabel,
            titleLabel,
            availabilityLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var imageLoadTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        productImageView.image = nil
        priceLabel.text = nil
        regularPriceLabel.text = nil
        fulfillmentLabel.text = nil
        titleLabel.text = nil
        availabilityLabel.text = nil
    }

    func configure(with deal: DealEntity, imageLoader: ImageLoaderProtocol?, theme: ListViewThemeable? = nil) {
        if let theme = theme {
            self.theme = theme
        }
        
        priceLabel.text = deal.displayPrice
        regularPriceLabel.text = deal.displayRegularPrice
        regularPriceLabel.isHidden = !deal.isOnSale
        fulfillmentLabel.text = deal.fulfillmentText
        titleLabel.text = deal.title
        availabilityLabel.attributedText = deal.availabilityAttributedText(theme: self.theme)
        
        if let url = deal.imageUrl {
            loadImage(from: url, using: imageLoader, productName: deal.title)
        }
    }
    
}


extension DealListCell {
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(contentStackView)
        contentView.addSubview(separatorView)
        
        let padding : CGFloat = 16
        let imageSize: CGFloat = 140
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: imageSize),
            productImageView.heightAnchor.constraint(equalToConstant: imageSize),
            
            contentStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            contentStackView.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        contentStackView.setCustomSpacing(2, after: priceStackView)
        contentStackView.setCustomSpacing(8, after: fulfillmentLabel)
        contentStackView.setCustomSpacing(4, after: titleLabel)
        
        applyTheme()
    }
    
    private func bindTheme() {
        ThemeManager.shared.themePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTheme in
                self?.theme = ThemeManager.shared.makeListViewTheme()
            }
            .store(in: &cancellables)
    }
    
    private func applyTheme() {
        backgroundColor = theme.cellBackgroundColor

        productImageView.layer.cornerRadius = 8
        productImageView.backgroundColor = theme.imagePlaceholderColor

        priceLabel.font = theme.priceFont
        priceLabel.textColor = theme.salePriceColor

        regularPriceLabel.font = theme.regularPriceFont
        regularPriceLabel.textColor = theme.regularPriceColor

        fulfillmentLabel.font = theme.captionFont
        fulfillmentLabel.textColor = theme.captionColor

        titleLabel.font = theme.titleFont
        titleLabel.textColor = theme.titleColor
        separatorView.backgroundColor = theme.separatorColor
    }
    
    
    private func loadImage(from url: URL, using loader: ImageLoaderProtocol?, productName: String = "") {
        imageLoadTask?.cancel()
        
        guard let loader = loader else {
            return
        }
        
        imageLoadTask = Task { [weak self] in
            do {
                let image = try await loader.loadImage(from: url)
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self?.productImageView.image = image
                }
            } catch {
                logger.log("error showing image")
            }
        }
    }
}
