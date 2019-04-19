//
//  AppAppearance.swift
//  MSGG
//
//  Created by Maxim Solovyov on 15/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

struct AppAppearance {
    
    static let unfocusedAlpha: CGFloat = 0.8
    static let streamsItemListLayout = ItemListLayout.wide3Row
    static let categoriesItemListLayout = ItemListLayout.poster7Row
    static let offlineFavoritesItemListLayout = ItemListLayout(itemSize: CGSize(width: 204, height: 271), horizontalSpacing: 52, verticalSpacing: 50)
}
