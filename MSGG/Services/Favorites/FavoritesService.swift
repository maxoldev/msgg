//
//  FavoritesService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 11/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import TVServices
import MSGGCore
import MSGGAPI

struct FavoriteStreamInfo: Codable {
    let channelID: MSGGCore.IDType
    let streamer: String
    let avatarURL: String
}

class FavoritesService: FavoritesServiceProtocol {
    
    static let listUpdatedNotification = Notification.Name("FavoritesService.listUpdatedNotification")
    
    fileprivate(set) var favoriteStreamInfoList: [FavoriteStreamInfo]
    fileprivate let streamsService: StreamsServiceProtocol
    fileprivate var onlineStreams = [MSGGCore.Stream]()
    fileprivate var offlineStreamInfos = [FavoriteStreamInfo]()
    
    init(streamsService: StreamsServiceProtocol) {
        self.streamsService = streamsService
        
        if let data = FavoritesService.userDefaults.data(forKey: UserDefaultsKeys.favorites.rawValue) {
            favoriteStreamInfoList = try! JSONDecoder().decode([FavoriteStreamInfo].self, from: data)
        } else {
            favoriteStreamInfoList = []
        }
    }
    
    fileprivate static var userDefaults: UserDefaults {
        return UserDefaults.init(suiteName: Appex.sharedSuiteName)!
    }
    
    func getStreams(completion: @escaping (Result<(online: [MSGGCore.Stream], offline: [FavoriteStreamInfo]), Error>) -> ()) {
        streamsService.getStreams(limit: 2000, gameURL: nil, skipStreamsWithoutSupportedVideo: false) { result in
            switch result {
            case let .success(streams):
                let favoriteStreamIDSet = Set(self.favoriteStreamInfoList.map({ $0.channelID }))
                let onlineFavoriteStreams = streams.filter({ favoriteStreamIDSet.contains($0.channelID) })
                let onlineStreamIDSet = Set(onlineFavoriteStreams.map({ $0.channelID }))
                let offlineStreamIDSet = favoriteStreamIDSet.subtracting(onlineStreamIDSet)
                let offlineFavoriteStreamInfoList = self.favoriteStreamInfoList.filter({ offlineStreamIDSet.contains($0.channelID) })
                self.onlineStreams = onlineFavoriteStreams
                self.offlineStreamInfos = offlineFavoriteStreamInfoList.sorted(by: { $0.streamer > $1.streamer })
                completion(.success((onlineFavoriteStreams, offlineFavoriteStreamInfoList)))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func addToFavorites(stream: MSGGCore.Stream) {
        guard !favoriteStreamInfoList.contains(where: { $0.channelID == stream.channelID }) else {
            Logger.warning("Stream with ID \(stream.channelID) has been already contained in favorites list")
            return
        }
        defer {
            notifyChanges()
        }
        let indexToInsert = onlineStreams.firstIndex(where: { $0.viewers <= stream.viewers }) ?? onlineStreams.endIndex
        onlineStreams.insert(stream, at: indexToInsert)
        let favStreamInfo = FavoriteStreamInfo(channelID: stream.channelID, streamer: stream.streamer, avatarURL: stream.avatarURL)
        favoriteStreamInfoList.append(favStreamInfo)
        saveListOnDisk()
    }

    func addToFavorites(offlineStreamInfo: FavoriteStreamInfo) {
        guard !favoriteStreamInfoList.contains(where: { $0.channelID == offlineStreamInfo.channelID }) else {
            Logger.warning("Stream with ID \(offlineStreamInfo.channelID) has been already contained in favorites list")
            return
        }
        defer {
            notifyChanges()
        }
        offlineStreamInfos.insert(offlineStreamInfo, at: 0)
        favoriteStreamInfoList.append(offlineStreamInfo)
        saveListOnDisk()
    }

    func removeFromFavorites(channelID: IDType) {
        guard favoriteStreamInfoList.contains(where: { $0.channelID == channelID }) else {
            Logger.warning("Stream with ID \(channelID) hasn't been contained in favorites list")
            return
        }
        defer {
            notifyChanges()
        }
        onlineStreams.removeAll(where: { $0.channelID == channelID })
        offlineStreamInfos.removeAll(where: { $0.channelID == channelID })
        favoriteStreamInfoList.removeAll(where: { $0.channelID == channelID })
        saveListOnDisk()
    }
    
    func isFavorite(channelID: IDType) -> Bool {
        return favoriteStreamInfoList.contains(where: { $0.channelID == channelID })
    }
    
    fileprivate func saveListOnDisk() {
//        favoriteStreamInfoList.append(FavoriteStreamInfo(channelID: 999, streamer: "Test", avatarURL: ""))
        let data = try! JSONEncoder().encode(favoriteStreamInfoList)
        FavoritesService.userDefaults.set(data, forKey: UserDefaultsKeys.favorites.rawValue)
        FavoritesService.userDefaults.synchronize()
    }
    
    fileprivate func notifyChanges() {
        NotificationCenter.default.post(name: FavoritesService.listUpdatedNotification, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.TVTopShelfItemsDidChange, object: nil)
    }
}
