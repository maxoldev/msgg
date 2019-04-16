//
//  ServiceProvider.swift
//  TopShelf
//
//  Created by Maxim Solovyov on 15/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import TVServices

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
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
        
        onlineFavoriteStreamsSection.title = NSLocalizedString("Live Followed Streams", comment: "")
        
        let onlineStreams = getOnlineFavoriteStreamsSynchronously()
        var favoriteStreamItems = onlineStreams.map { (stream) -> TVContentItem in
            let item = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "\(stream.channelID)", container: onlineFavoriteStreamsSectionIdentifier))
            item.setImageURL(URL(string: stream.previewURL), forTraits: [])
            item.imageShape = .HDTV
            item.title = "\(stream.streamer) - \(stream.title)"
            return item
        }
        let addTestItem = false
        if addTestItem {
            favoriteStreamItems.append(makeTestItem(withTitle: "Test", container: onlineFavoriteStreamsSectionIdentifier))
        }
        onlineFavoriteStreamsSection.topShelfItems = favoriteStreamItems

        return [onlineFavoriteStreamsSection]
    }
    
    fileprivate func getOnlineFavoriteStreamsSynchronously() -> [Stream] {
        var streams = [Stream]()
        let semaphore = DispatchSemaphore(value: 0)
        
        let favoritesService = FavoritesService(streamsService: StreamsService())
        favoritesService.getStreams { (onlineStreams, _, error) in
            defer {
                semaphore.signal()
            }
            guard error == nil else {
                return
            }
            streams = onlineStreams
        }
        semaphore.wait()
        
        return streams
    }
    
    fileprivate func makeTestItem(withTitle title: String, container: TVContentIdentifier?) -> TVContentItem {
        let testItem = TVContentItem(contentIdentifier: TVContentIdentifier(identifier: "test", container: container))
        testItem.setImageURL(URL(string: ""), forTraits: [])
        testItem.imageShape = .HDTV
        testItem.title = title
        return testItem
    }
}
