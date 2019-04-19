//
//  FavoritesService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

protocol FavoritesService {
    
    func getStreams(completion: @escaping (_ online: [Stream], _ offline: [FavoriteStreamInfo], Error?) -> ())
    func addToFavorites(stream: Stream)
    func addToFavorites(offlineStreamInfo: FavoriteStreamInfo)
    func removeFromFavorites(channelID: IDType)
    func isFavorite(channelID: IDType) -> Bool
}
