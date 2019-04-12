//
//  GoodGame.swift
//  MSGG
//
//  Created by Maxim Solovyov on 28/03/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

struct GoodGame {

    struct Streams: Decodable {
        let _links: Links
        let _embedded: StreamsEmbedded
    }
    
    struct StreamsEmbedded: Decodable {
        let streams: [Stream]
    }
    
    struct Stream: Decodable {
        let request_key: String
        let id: Int
        let key: String
        let is_broadcast: Bool
        let url: String
        let status: String
        let viewers: String
        let channel: Channel
    }
    
    struct Channel: Decodable {
        let gg_player_src: String
        let title: String
        let img: String
        let thumb: String
        let games: [GameShort]
    }
    
    struct GameShort: Decodable {
        let title: String
        let url: String
    }
    
    struct Game: Decodable {
        let title: String
        let url: String
        let poster: String
    }

    struct PlayerInfo: Decodable {
        let streamer_avatar: String
    }
    
    struct Link: Decodable {
        let href: String
    }
    
    struct Links: Decodable {
        let `self`: Link
        let first: Link
        let last: Link
        let next: Link
    }
}
