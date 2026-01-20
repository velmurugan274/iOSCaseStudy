//
//  ThemeManager.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

// MARK: - ThemeManager Protocol

public protocol ThemeManagerProtocol: AnyObject {
    var currentTheme: Theme { get }
    var themePublisher: AnyPublisher<Theme, Never> { get }
    
    func setTheme(_ theme: Theme)
    
    // Factory methods for view-specific themes
    func makeListViewTheme() -> ListViewThemeable
    func makeDetailViewTheme() -> DetailViewThemeable
    func makeNavigationTheme() -> NavigationThemeable
}

// MARK: - ThemeManager Implementation

public final class ThemeManager: ThemeManagerProtocol, ObservableObject {
    
    public static let shared = ThemeManager()
    
    @Published public private(set) var currentTheme: Theme
    
    public var themePublisher: AnyPublisher<Theme, Never> {
        $currentTheme.eraseToAnyPublisher()
    }
    
    private init(theme: Theme = TargetTheme.shared) {
        self.currentTheme = theme
    }
    
    public func setTheme(_ theme: Theme) {
        currentTheme = theme
        NotificationCenter.default.post(name: .themeDidChange, object: theme)
    }
    
    // MARK: - Factory Methods
    
    public func makeListViewTheme() -> ListViewThemeable {
        ListViewTheme(theme: currentTheme)
    }
    
    public func makeDetailViewTheme() -> DetailViewThemeable {
        DetailViewTheme(theme: currentTheme)
    }
    
    public func makeNavigationTheme() -> NavigationThemeable {
        NavigationTheme(theme: currentTheme)
    }
}

// MARK: - Notification Extension

public extension Notification.Name {
    static let themeDidChange = Notification.Name("ThemeDidChangeNotification")
}

// MARK: - SwiftUI Environment Keys

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = TargetTheme.shared
}

private struct DetailViewThemeKey: EnvironmentKey {
    static let defaultValue: DetailViewThemeable = DetailViewTheme()
}

public extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
    
    var detailViewTheme: DetailViewThemeable {
        get { self[DetailViewThemeKey.self] }
        set { self[DetailViewThemeKey.self] = newValue }
    }
}

// MARK: - SwiftUI View Extension

public extension View {
    func themed(_ theme: Theme = ThemeManager.shared.currentTheme) -> some View {
        self
            .environment(\.theme, theme)
            .environment(\.detailViewTheme, DetailViewTheme(theme: theme))
    }
}
