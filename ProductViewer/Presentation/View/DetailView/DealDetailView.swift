import SwiftUI

struct DealDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.detailViewTheme) var theme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var viewModel: DealDetailViewModel
    
    private var isRegularWidth: Bool {
        horizontalSizeClass == .regular
    }
    
    private var contentMaxWidth: CGFloat {
        isRegularWidth ? 800 : .infinity
    }
    
    private var isAvailable: Bool {
        viewModel.deal.isAvailable
    }
    
    var body: some View {
        ZStack {
            theme.backgroundColor.color
                .ignoresSafeArea()
            contentView
        }
        .navigationTitle(Strings.Navigation.detailTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.loadData() }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            loadingView
        case .loaded:
            loadedContentView
        case .error(let error):
            errorView(error: error)
        }
    }
    
    private var loadingView: some View {
        Color.clear
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(theme.primaryColor.color)
                    
                    Text(Strings.DealDetail.loading)
                        .font(theme.bodyFont.font)
                        .foregroundColor(theme.bodyColor.color)
                }
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.DealDetail.loadingView)
    }
    
    private var loadedContentView: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        productImageSection(geometry: geometry)
                        productInfoSection
                        productDetailsSection
                    }
                    .frame(maxWidth: contentMaxWidth)
                    .frame(maxWidth: .infinity)
                }
            }
            cartActionBar
        }
    }
    
    @ViewBuilder
    private func productImageSection(geometry: GeometryProxy) -> some View {
        let imageSize: CGFloat = min(geometry.size.width - 32, 800)
        
        HStack {
            Spacer()
            AsyncImage(url: viewModel.deal.imageUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(theme.captionColor.color)
                case .empty:
                    ProgressView()
                        .tint(theme.primaryColor.color)
                @unknown default:
                    EmptyView()
                }
                
            }
            .background(theme.imagePlaceholderColor.color)
            .cornerRadius(8)
            Spacer()
        }
        .frame(width: imageSize, height: imageSize)
        .padding(.horizontal, 16)
    }
    
    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.deal.title)
                .font(theme.titleFont.font)
                .foregroundColor(theme.titleColor.color)
                .accessibilityIdentifier(AccessibilityIdentifiers.DealDetail.productTitle)
            
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(viewModel.deal.displayPrice)
                    .font(theme.priceFont.font)
                    .foregroundColor(theme.priceColor.color)
                    .accessibilityIdentifier(AccessibilityIdentifiers.DealDetail.productPrice)
                
                if let regularPrice = viewModel.deal.displayRegularPrice {
                    Text(regularPrice)
                        .font(theme.strikethroughFont.font)
                        .foregroundColor(theme.strikethroughColor.color)
                }
            }
            
            Text(viewModel.deal.fulfillmentText)
                .font(theme.captionFont.font)
                .foregroundColor(theme.captionColor.color)
            
            Text(viewModel.deal.availabilityText)
                .font(theme.captionFont.font)
                .foregroundColor(availabilityColor)
        }
        .padding(.horizontal, 16)
    }
    
    private var availabilityColor: Color {
        switch viewModel.deal.availabilityStatus {
        case .inStock:
            return theme.successColor.color
        case .limitedStock:
            return theme.warningColor.color
        case .outOfStock:
            return theme.errorColor.color
        case .unknown:
            return theme.captionColor.color
        }
    }
    
    private var productDetailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Strings.DealDetail.productDetailsHeader)
                .font(theme.headlineFont.font)
                .foregroundColor(theme.titleColor.color)
                .padding(.top, 12)
            
            Text(viewModel.deal.description)
                .font(theme.bodyFont.font)
                .foregroundColor(theme.bodyColor.color)
                .padding(.bottom, 12)
        }
        .padding(.horizontal, 16)
    }
    
    private var cartActionBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            if !isAvailable {
                outOfStockButton
            } else if viewModel.isInCart {
                quantityStepperView
            } else {
                addToCartButton
            }
        }
        .background(theme.surfaceColor.color)
    }
    
    private var outOfStockButton: some View {
        Text(Strings.DealDetail.outOfStock)
            .font(theme.buttonFont.font)
            .foregroundColor(theme.captionColor.color)
            .frame(height: 50)
            .frame(maxWidth: 600)
            .background(theme.surfaceVariantColor.color)
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }
    
    private var addToCartButton: some View {
        Button {
            viewModel.addToCart()
        } label: {
            Text(Strings.DealDetail.addToCart)
                .font(theme.buttonFont.font)
                .foregroundColor(theme.buttonTextColor.color)
                .frame(height: 50)
                .frame(maxWidth: 600)
                .background(theme.buttonBackgroundColor.color)
                .cornerRadius(8)
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.DealDetail.addToCartButton)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var quantityStepperView: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    viewModel.decrementQuantity()
                }
            } label: {
                Group {
                    if viewModel.quantity == 1 {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .medium))
                    } else {
                        Image(systemName: "minus")
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                .foregroundColor(theme.primaryColor.color)
                .frame(width: 50, height: 50)
                .background(theme.primaryColor.color.opacity(0.1))
                .cornerRadius(8)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.DealDetail.decrementButton)
            
            Text("\(viewModel.quantity)")
                .font(theme.titleFont.font)
                .foregroundColor(theme.titleColor.color)
                .frame(minWidth: 50)
                .accessibilityIdentifier(AccessibilityIdentifiers.DealDetail.quantityLabel)
            
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    viewModel.incrementQuantity()
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(viewModel.canIncrement ? theme.primaryColor.color : theme.captionColor.color)
                    .frame(width: 50, height: 50)
                    .background(
                        viewModel.canIncrement
                        ? theme.primaryColor.color.opacity(0.1)
                        : theme.surfaceVariantColor.color
                    )
                    .cornerRadius(8)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.DealDetail.incrementButton)
            .disabled(!viewModel.canIncrement)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func errorView(error: DealDetailViewState.DealDetailError) -> some View {
        ContentUnavailableWrapper(configuration: .detailError(error),
            action: error.canRetry ? { viewModel.retry() } : { presentationMode.wrappedValue.dismiss() })
    }
}

