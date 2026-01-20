//
//  DealDetailHostingController.swift
//  ProductViewer
//
//  Created by Velmurugan on 20/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit
import SwiftUI

final class DealDetailHostingController: UIHostingController<AnyView> {
    
    init(viewModel: DealDetailViewModel, detailTheme: DetailViewThemeable = DetailViewTheme(),
        baseTheme: Theme = ThemeManager.shared.currentTheme) {
        let view = DealDetailView(viewModel: viewModel)
            .environment(\.detailViewTheme, detailTheme)
            .themed(baseTheme)
        super.init(rootView: AnyView(view))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
