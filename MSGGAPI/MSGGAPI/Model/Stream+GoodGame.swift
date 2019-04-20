//
//  Stream+Goodgame.swift
//  MSGGAPI
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore

extension String {
    
    var normalizedGGURL: String {
        guard var urlComponents = URLComponents(string: self) else {
            return ""
        }
        urlComponents.scheme = "https"
        if urlComponents.host == nil {
            urlComponents.host = APIConstants.host
        }
        let url = urlComponents.url?.absoluteString ?? ""
        return url
    }
}

extension MSGGCore.StreamSource {
    
    init?(id: String, url: String) {
        if id == StreamQuality.sourceID {
            if url.hasSuffix(APIConstants.smilExt) {
                return nil
            } else {
                self.init(quality: .source, url: url)
            }
        } else if let resolution = Int(id) {
            self.init(quality: .scaled(resolution: resolution), url: url)
        } else {
            return nil
        }
    }
}

extension MSGGCore.Stream {
    
    public init(goodgameStream: GoodGame.Stream) {
        let gg = goodgameStream
        let sources = gg.sources.compactMap({ (key: String, value: String) -> StreamSource? in
            return StreamSource(id: key, url: value)
        }).sorted(by: >)
        
        self.init(channelID: gg.id, title: gg.title, streamer: gg.streamer ?? "", avatarURL: gg.avatar.normalizedGGURL, viewers: gg.viewers, playerSrc: gg.streamkey, previewURL: gg.preview.normalizedGGURL, channelPosterURL: gg.poster, gameID: gg.game, isOnline: gg.status, sources: sources)
    }
}

extension GoodGame.Stream {
    
    public init(stream: MSGGCore.Stream) {
        let sources = Dictionary(uniqueKeysWithValues: stream.sources.map({ ($0.quality.key, $0.url) }))
        self.init(id: stream.channelID, title: stream.title, streamer: stream.streamer, avatar: stream.avatarURL, game: stream.gameID, viewers: stream.viewers, preview: stream.previewURL, poster: stream.channelPosterURL, streamkey: stream.playerSrc, status: stream.isOnline, sources: sources)
    }
}

extension MSGGCore.Game {
    
    init(goodgameGame: GoodGame.Game) {
        self.init(gameID: goodgameGame.id, url: goodgameGame.url, coverURL: goodgameGame.poster ?? "", title: goodgameGame.title ?? "")
    }
}

extension MSGGCore.Genre {
    
    init(goodgameGenre: GoodGame.Genre) {
        self.init(enTitle: goodgameGenre.title, ruTitle: goodgameGenre.ru, coverURL: goodgameGenre.cover)
    }
}
