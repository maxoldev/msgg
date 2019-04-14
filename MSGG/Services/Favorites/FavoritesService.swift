//
//  FavoritesService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 11/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

struct FavoriteStreamInfo: Codable {
    let channelID: IDType
    let streamer: String
    let avatarURL: String
}

class FavoritesService {
    
    fileprivate(set) var favoriteStreamInfoList: [FavoriteStreamInfo]
    fileprivate let streamsService: StreamsService
    
    init(streamsService: StreamsService) {
        self.streamsService = streamsService
        
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.favorites.rawValue) {
            favoriteStreamInfoList = try! JSONDecoder().decode([FavoriteStreamInfo].self, from: data)
        } else {
            favoriteStreamInfoList = []
        }
    }
    
    func getStreams(completion: @escaping (_ online: [Stream], _ offline: [FavoriteStreamInfo], Error?) -> ()) {
        streamsService.getStreams(skipStreamsWithoutSupportedVideo: true) { [weak self] (streams, error) in
            guard error == nil, let self = self else {
                return
            }
            let favoriteStreamIDSet = Set(self.favoriteStreamInfoList.map({ $0.channelID }))
            let onlineFavoriteStreams = streams.filter({ favoriteStreamIDSet.contains($0.channelID) })
            let onlineStreamIDSet = Set(onlineFavoriteStreams.map({ $0.channelID }))
            let offlineStreamIDSet = favoriteStreamIDSet.subtracting(onlineStreamIDSet)
            let offlineFavoriteStreamInfoList = self.favoriteStreamInfoList.filter({ offlineStreamIDSet.contains($0.channelID) })
            completion(onlineFavoriteStreams, offlineFavoriteStreamInfoList, nil)
        }
    }
    
    func addToFavorites(stream: Stream) {
        let favStreamInfo = FavoriteStreamInfo(channelID: stream.channelID, streamer: stream.streamer, avatarURL: stream.avatarURL)
        favoriteStreamInfoList.append(favStreamInfo)
        saveListOnDisk()
    }

    func removeFromFavorites(channelID: IDType) {
        favoriteStreamInfoList.removeAll(where: { $0.channelID == channelID })
        saveListOnDisk()
    }
    
    func isFavorite(channelID: IDType) -> Bool {
        return favoriteStreamInfoList.contains(where: { $0.channelID == channelID })
    }
    
    fileprivate func saveListOnDisk() {
        let data = try! JSONEncoder().encode(favoriteStreamInfoList)
        UserDefaults.standard.set(data, forKey: UserDefaultsKeys.favorites.rawValue)
    }
}
