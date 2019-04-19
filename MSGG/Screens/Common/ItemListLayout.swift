//
//  ItemListLayout.swift
//  MSGG
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

struct ItemListLayout {

    let itemSize: CGSize
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    
    static let wide3Row = ItemListLayout(itemSize: CGSize(width: 548, height: 399), horizontalSpacing: 48, verticalSpacing: 100)
    static let wide4Row = ItemListLayout(itemSize: CGSize(width: 375, height: 301), horizontalSpacing: 80, verticalSpacing: 50)
    static let poster7Row = ItemListLayout(itemSize: CGSize(width: 204, height: 384), horizontalSpacing: 48, verticalSpacing: 80)
}
