//
//  CatergoryListVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class CatergoryListVC<T>: ItemListVC<T> {

    override func registerCellAndViews() {
        super.registerCellAndViews()
        collectionView.register(UINib(nibName: String(describing: CategoryCVCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CategoryCVCell.self))
    }

    override var itemListLayout: ItemListLayout {
        return AppAppearance.categoriesItemListLayout
    }
}
