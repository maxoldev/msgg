//
//  Stream+Goodgame.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

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

extension Stream {
    
    init(goodgameStream: GoodGame.Stream) {
        let gg = goodgameStream
        let sources = gg.sources.compactMap({ (key: String, value: String) -> StreamSource? in
            return StreamSource(id: key, url: value)
        }).sorted(by: >)
        
        self.init(channelID: gg.id, title: gg.title, streamer: gg.streamer ?? "", avatarURL: gg.avatar.normalizedGGURL, viewers: gg.viewers, playerSrc: gg.streamkey, previewURL: gg.preview.normalizedGGURL, channelPosterURL: gg.poster, gameID: gg.game, isOnline: gg.status, sources: sources)
    }
}

extension GoodGame.Stream {
    
    init(stream: Stream) {
        let sources = Dictionary(uniqueKeysWithValues: stream.sources.map({ ($0.quality.key, $0.url) }))
        self.init(id: stream.channelID, title: stream.title, streamer: stream.streamer, avatar: stream.avatarURL, game: stream.gameID, viewers: stream.viewers, preview: stream.previewURL, poster: stream.channelPosterURL, streamkey: stream.playerSrc, status: stream.isOnline, sources: sources)
    }
}

extension Game {
    
    init(goodgameGame: GoodGame.Game) {
        self.init(gameID: goodgameGame.id, url: goodgameGame.url, coverURL: goodgameGame.poster ?? "", title: goodgameGame.title ?? "")
    }
}

extension Genre {
    
    init(goodgameGenre: GoodGame.Genre) {
        self.init(enTitle: goodgameGenre.title, ruTitle: goodgameGenre.ru, coverURL: goodgameGenre.cover)
    }
}
