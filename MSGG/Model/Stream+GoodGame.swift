//
//  Stream+Goodgame.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

extension Stream {
    
    init(goodgameStream: GoodGame.Stream) {
        let gg = goodgameStream
        let viewers = Int(gg.viewers) ?? 0
        let game = Game(coverURL: gg.channel.img, title: gg.channel.games.first?.title ?? "", url: gg.channel.games.first?.url ?? "")
        self.init(channelID: gg.id, streamer: gg.key, url: gg.url, viewers: viewers, playerSrc: gg.channel.gg_player_src, title: gg.channel.title ?? "", thumbURL: Stream.makeThumbURLString(incompleteURL: gg.channel.thumb), game: game)
    }
    
    fileprivate static func makeThumbURLString(incompleteURL: String) -> String {
        var thumbURLComponents = URLComponents(string: incompleteURL)!
        thumbURLComponents.scheme = "https"
        let thumbURL = thumbURLComponents.url?.absoluteString ?? ""
        return thumbURL
    }
}

extension Game {
    
    init(goodgameGame: GoodGame.Game) {
        self.init(coverURL: goodgameGame.poster ?? "", title: goodgameGame.title ?? "", url: goodgameGame.url ?? "")
    }
}

extension Genre {
    
    init(goodgameGenre: GoodGame.Genre) {
        self.init(enTitle: goodgameGenre.title, ruTitle: goodgameGenre.ru, coverURL: goodgameGenre.cover)
    }
}
