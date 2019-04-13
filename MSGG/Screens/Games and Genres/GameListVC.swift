//
//  GameListVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class GameListVC: CatergoryListVC<Game> {

    let service = CategoriesService()
    
    override func loadData() {
        collectionView.isHidden = true
        activityIndicator.startAnimating()
        service.getCategories { [weak self] (games, genres, error) in
            guard let self = self else {
                return
            }
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
            
            guard error == nil else {
                return
            }
            self.items = games
            self.collectionView.reloadData()
            self.setNeedsFocusUpdate()
        }
    }
    
    //MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCVCell.self), for: indexPath) as! CategoryCVCell
        let category = items[indexPath.row]
        cell.setup(title: category.title, streams: 0, thumbURL: category.coverURL)
        return cell
    }
}
