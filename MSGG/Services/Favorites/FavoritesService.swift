//
//  FavoritesService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 11/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class FavoritesService {
    
    fileprivate(set) var favoriteStreamIDList: [ChannelID]
    
    init() {
        if let idArray = UserDefaults.standard.array(forKey: UserDefaultsKeys.favorites.rawValue) as? [ChannelID] {
            favoriteStreamIDList = idArray
        } else {
            favoriteStreamIDList = []
        }
    }
    
    func addToFavorites(channelID: ChannelID) {
        favoriteStreamIDList.append(channelID)
        saveListOnDisk()
    }

    func removeFromFavorites(channelID: ChannelID) {
        favoriteStreamIDList.removeAll(where: {$0 == channelID})
        saveListOnDisk()
    }

//    func getFavoriteChannelIDs() -> [ChannelID] {
//        return favoriteStreamIDList
//    }
    
    func isFavorite(channelID: ChannelID) -> Bool {
        return favoriteStreamIDList.contains(channelID)
    }
    
    fileprivate func saveListOnDisk() {
        UserDefaults.standard.set(favoriteStreamIDList, forKey: UserDefaultsKeys.favorites.rawValue)
    }
}
