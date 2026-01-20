//
//  CollectionViewLayout.swift
//  ProductViewer
//
//  Created by Velmurugan on 19/01/26.
//  Copyright © 2026 Target. All rights reserved.
//

import UIKit

enum CollectionViewLayoutFactory {
    
    static func createAdaptiveDealListLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, environment in 
            let availableWidth = environment.container.effectiveContentSize.width
            let minItemWidth: CGFloat = 300
            let computedColumns = Int(availableWidth / minItemWidth)
            let columns = max(1, computedColumns)
            
            let estimatedHeight: CGFloat = 172
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
                heightDimension: .estimated(estimatedHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(estimatedHeight))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item,
                count: columns)
            
            group.interItemSpacing = .fixed(16)
            
            let section = NSCollectionLayoutSection(group: group)
            
            let sidePadding: CGFloat = (columns == 1) ? 0 : 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sidePadding, bottom: 0,
                trailing: sidePadding)
            
            return section
        }
    }
}

