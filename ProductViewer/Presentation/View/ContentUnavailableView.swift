//
//  ContentUnavailableView.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import SwiftUI


struct ContentUnavailableConfiguration {
    let title: String
    let description: String
    let systemImage: String
    let actionTitle: String?
    
    // MARK: - Factory Methods
    
    static var emptyDeals: ContentUnavailableConfiguration {
        ContentUnavailableConfiguration(
            title: Strings.DealList.emptyTitle,
            description: Strings.DealList.emptyMessage,
            systemImage: "tag.slash",
            actionTitle: Strings.DealList.emptyRefresh)
    }
    
    static var networkError: ContentUnavailableConfiguration {
        ContentUnavailableConfiguration(title: Strings.DealList.errorTitle,
                                        description: Strings.Error.networkUnavailable,
                                        systemImage: "wifi.slash",
                                        actionTitle: Strings.DealList.errorRetry)
    }
    
    static var notFound: ContentUnavailableConfiguration {
        ContentUnavailableConfiguration(title: Strings.Error.notFoundTitle,
            description: Strings.Error.notFound,
            systemImage: "magnifyingglass",
            actionTitle: nil)
    }
    
    static func custom(title: String, description: String,systemImage: String,
                       actionTitle: String? = nil) -> ContentUnavailableConfiguration {
        ContentUnavailableConfiguration(title: title, description: description, systemImage: systemImage, actionTitle: actionTitle)
    }
    
    static func detailError(_ error: DealDetailViewState.DealDetailError) -> ContentUnavailableConfiguration {
        ContentUnavailableConfiguration(
            title: error.title,
            description: error.message,
            systemImage: error.systemImage,
            actionTitle: error.canRetry ? Strings.DealDetail.tryAgain : Strings.DealDetail.goBack
        )
    }
}


struct ContentUnavailableWrapper: View {
    let configuration: ContentUnavailableConfiguration
    let action: (() -> Void)?
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        if #available(iOS 17.0, *) {
            ios17View
        } else {
            fallbackView
        }
    }
    
    @available(iOS 17.0, *)
    private var ios17View: some View {
        ContentUnavailableView {
            Label(configuration.title, systemImage: configuration.systemImage)
        } description: {
            Text(configuration.description)
        } actions: {
            if let actionTitle = configuration.actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(theme.colors.primary.color)
                    
            }
        }
    }
    
    private var fallbackView: some View {
        VStack(spacing: 16) {
            Image(systemName: configuration.systemImage)
                .font(.system(size: 56))
                .foregroundColor(theme.colors.textTertiary.color)
            
            Text(configuration.title)
                .font(theme.fonts.headline2.font)
                .foregroundColor(theme.colors.textPrimary.color)
                .multilineTextAlignment(.center)
            
            Text(configuration.description)
                .font(theme.fonts.bodyMedium.font)
                .foregroundColor(theme.colors.textSecondary.color)
                .multilineTextAlignment(.center)
            
            if let actionTitle = configuration.actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(theme.fonts.button.font)
                        .foregroundColor(theme.colors.buttonText.color)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(theme.colors.buttonBackground.color)
                        .cornerRadius(8)
                }
                .padding(.top, 12)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background.color)
    }
}
