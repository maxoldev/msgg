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
            urlComponents.host = "goodgame.ru"
        }
        let url = urlComponents.url?.absoluteString ?? ""
        return url
    }
}

extension Stream {
    
    init(goodgameStream: GoodGame.Stream) {
        let gg = goodgameStream
        let sources = gg.sources.compactMap({ (key: String, value: String) -> StreamSource? in
            if key == "source" {
                if value.hasSuffix(APIConstants.smilExt) {
                    return nil
                } else {
                    return StreamSource(quality: .source, url: value)
                }
            } else if let resolution = Int(key) {
                return StreamSource(quality: .scaled(resolution: resolution), url: value)
            } else {
                return nil
            }
        }).sorted(by: { (q1, q2) -> Bool in
            switch (q1.quality, q2.quality) {
            case (.source, _):
                return true
            case (_, .source):
                return false
            case let (.scaled(resolution1), .scaled(resolution2)):
                return resolution1 > resolution2
            }
        })
        self.init(channelID: gg.id, title: gg.title, streamer: gg.streamer ?? "", avatarURL: gg.avatar.normalizedGGURL, viewers: gg.viewers, playerSrc: gg.streamkey, previewURL: gg.preview.normalizedGGURL, channelPosterURL: gg.poster, gameID: gg.game, sources: sources)
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
