//
//  GameListVC.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import MSGGCore
import MSGGAPI

class GameListVC: CatergoryListVC<Game> {

    fileprivate let service = DepedencyContainer.global.resolve(CategoriesServiceProtocol.self)!
    
    override func loadData() {
        isLoading = true
        
        service.getCategories { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.isLoading = false
                
                switch result {
                case let .success((games, _)):
                    self.items = games
                    self.collectionView.reloadData()
                    self.setNeedsFocusUpdate()
                    
                case .failure:
                    break
                }
            }
        }
    }
    
    //MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCVCell.self), for: indexPath) as! CategoryCVCell
        let category = items[indexPath.row]
        cell.setup(title: category.title, streams: 0, thumbURL: category.coverURL)
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = items[indexPath.row]
        DepedencyContainer.global.resolve(GameListRouterProtocol.self)!.didSelectGame(game)
    }
}
