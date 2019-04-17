//
//  GameListVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class GenreListVC: CatergoryListVC<Genre> {
    
    let service = CategoriesService()
    
    override func loadData() {
        isLoading = true
        
        service.getCategories { [weak self] (games, genres, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard error == nil, let self = self else {
                    return
                }
                self.items = genres
                self.collectionView.reloadData()
                self.setNeedsFocusUpdate()
            }
        }
    }

    //MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCVCell.self), for: indexPath) as! CategoryCVCell
        let genre = items[indexPath.row]
        cell.setup(title: genre.localizedTitle, streams: 0, thumbURL: genre.coverURL)
        return cell
    }

    //MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let genre = items[indexPath.row]
//        let vc = SharedComponents.vcFactory.create(.streamList) as StreamListVC
//        navigationController?.pushViewController(vc, animated: true)
    }
}
