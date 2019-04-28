//
//  ServiceProvider.swift
//  TopShelf
//
//  Created by Maxim Solovyov on 15/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import TVServices
import Swinject
import MSGGCore
import MSGGAPI
import MSGGFavorites

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
        registerDependencies()
    }

    fileprivate func registerDependencies() {
        let container = DepedencyContainer.global
        container.register(StreamsServiceProtocol.self, factory: { _ in StreamsService() })
        container.register(FavoritesServiceProtocol.self) { r in
            let streamsService = r.resolve(StreamsServiceProtocol.self)!
            let userDefaults = UserDefaults.init(suiteName: CrossTargetConfig.sharedSuiteName)!
            let userDefaultsKeyToStoreList = UserDefaultsKeys.favorites.rawValue
            return FavoritesService(streamsService: streamsService, userDefaults: userDefaults, userDefaultsKeyToStoreList: userDefaultsKeyToStoreList)
        }
    }

    // MARK: - TVTopShelfProvider protocol

    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return .sectioned
    }

    var topShelfItems: [TVContentItem] {
        // Create an array of TVContentItems.
        let onlineFavoriteStreamsSectionIdentifier = TVContentIdentifier(identifier: "onlineFavoriteStreams", container: nil)
        let onlineFavoriteStreamsSection = TVContentItem(contentIdentifier: onlineFavoriteStreamsSectionIdentifier)
        
        onlineFavoriteStreamsSection.title = NSLocalizedString("live-followed-streams", comment: "")
        
        let onlineStreams = getOnlineFavoriteStreamsSynchronously()
        recreateImageCacheFolder()
        let favoriteStreamItems = onlineStreams.map { (stream) -> TVContentItem in
            let item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "\(stream.channelID)", container: onlineFavoriteStreamsSectionIdentifier))
            let imageURL = downloadImageWithURLAndReturnLocalURL(URL(string: stream.previewURL)!)
            item.setImageURL(imageURL, forTraits: [])
            item.imageShape = .HDTV
            item.title = "\(stream.streamer) - \(stream.title)"
            let url = makeURL(for: stream)
            item.playURL = url
            item.displayURL = url
            return item
        }
        
//        favoriteStreamItems.append(makeTestItem(withTitle: "test", container: onlineFavoriteStreamsSectionIdentifier))
        
        onlineFavoriteStreamsSection.topShelfItems = favoriteStreamItems

        return [onlineFavoriteStreamsSection]
    }
    
    fileprivate func getOnlineFavoriteStreamsSynchronously() -> [MSGGCore.Stream] {
        var streams = [MSGGCore.Stream]()
        let semaphore = DispatchSemaphore(value: 0)
        
        let favoritesService = DepedencyContainer.global.resolve(FavoritesServiceProtocol.self)!
        favoritesService.getStreams(limit: CrossTargetConfig.itemLimit) { result in
            defer {
                semaphore.signal()
            }
            switch result {
            case let .success((onlineStreams, _)):
                streams = onlineStreams
                
            case .failure:
                break
            }
        }
        semaphore.wait()
        
        return streams
    }
    
    fileprivate func makeURL(for stream: MSGGCore.Stream) -> URL? {
        var components = URLComponents()
        components.scheme = CrossTargetConfig.scheme
        let ggStream = GoodGame.Stream(stream: stream)
        guard let encoded = try? JSONEncoder().encode(ggStream) else {
            return nil
        }
        components.queryItems = [URLQueryItem(name: CrossTargetConfig.streamQueryItemName, value: String(data: encoded, encoding: .utf8))]
        return components.url
    }
    
    fileprivate func makeTestItem(withTitle title: String, container: TVContentIdentifier?) -> TVContentItem {
        let testItem = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "test", container: container))
        testItem.setImageURL(URL(string: ""), forTraits: [])
        testItem.imageShape = .HDTV
        testItem.title = title
        return testItem
    }
    
    fileprivate func downloadImageWithURLAndReturnLocalURL(_ url: URL) -> URL? {
        do {
            let data = try Data(contentsOf: url)
            let filename = "\(UUID())"
            let filepath = NSString(string: getImageCacheFolderPath).appendingPathComponent(filename)
            let localFileURL = URL(fileURLWithPath: filepath)
            try data.write(to: localFileURL)
            return localFileURL
        } catch {
            return nil
        }
    }
    
    fileprivate lazy var getImageCacheFolderPath: String = {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let imageCacheFolder = NSString(string: paths.first!).appendingPathComponent("preview_images")
        return imageCacheFolder
    }()
    
    fileprivate func recreateImageCacheFolder() {
        try? FileManager.default.removeItem(atPath: getImageCacheFolderPath)
        do {
            try FileManager.default.createDirectory(atPath: getImageCacheFolderPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            Logger.error(error)
        }
    }
}
