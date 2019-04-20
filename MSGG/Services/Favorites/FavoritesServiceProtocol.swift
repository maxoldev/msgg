//
//  FavoritesServiceProtocol.swift
//  MSGG
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore

protocol FavoritesServiceProtocol {
    
    func getStreams(completion: @escaping (_ online: [MSGGCore.Stream], _ offline: [FavoriteStreamInfo], Error?) -> ())
    func addToFavorites(stream: MSGGCore.Stream)
    func addToFavorites(offlineStreamInfo: FavoriteStreamInfo)
    func removeFromFavorites(channelID: IDType)
    func isFavorite(channelID: IDType) -> Bool
}
