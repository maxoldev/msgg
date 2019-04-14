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

    override var itemSize: CGSize {
        return CGSize(width: 204, height: 384)
    }
    
    override var horizontalSpacing: CGFloat {
        return 48
    }
    
    override var verticalSpacing: CGFloat {
        return 80
    }
}
