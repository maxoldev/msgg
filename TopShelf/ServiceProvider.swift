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

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
        registerDependencies()
    }

    fileprivate func registerDependencies() {
        let container = DepedencyContainer.global
        container.register(StreamsServiceProtocol.self, factory: { _ in StreamsService() })
        container.register(FavoritesServiceProtocol.self, factory: { r in FavoritesService(streamsService: r.resolve(StreamsServiceProtocol.self)!) })
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
        var favoriteStreamItems = onlineStreams.map { (stream) -> TVContentItem in
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
        favoritesService.getStreams { result in
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
        components.scheme = Appex.scheme
        let ggStream = GoodGame.Stream(stream: stream)
        guard let encoded = try? JSONEncoder().encode(ggStream) else {
            return nil
        }
        components.queryItems = [URLQueryItem(name: Appex.streamQueryItemName, value: String(data: encoded, encoding: .utf8))]
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
            let filename = url.lastPathComponent
            let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            let filepath = NSString(string: paths.first!).appendingPathComponent(filename)
            let localFileURL = URL(fileURLWithPath: filepath)
            try data.write(to: localFileURL)
            return localFileURL
        } catch {
            return nil
        }
    }
}
