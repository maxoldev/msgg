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
        let streams: [GoodGame.Stream]
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
        let title: String?
        let img: String
        let thumb: String
        let games: [GameShort]
    }
    
    struct GameShort: Decodable {
        let title: String?
        let url: String?
    }
    
    struct Game: Decodable {
        let title: String?
        let url: String?
        let poster: String?
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
    
    struct Categories: Decodable {
        enum RootKeys: CodingKey {
            case games, genres
        }
        
        enum GamesKeys: CodingKey {
            case list
        }

        let games: [GoodGame.Game]
        let genres: [GoodGame.Genre]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RootKeys.self)
            
            var gamesKeyedContainer = try container.nestedContainer(keyedBy: GamesKeys.self, forKey: .games)
            gamesKeyedContainer = try gamesKeyedContainer.nestedContainer(keyedBy: GamesKeys.self, forKey: .list)
            var gamesUnkeyedContainer = try gamesKeyedContainer.nestedUnkeyedContainer(forKey: .list)
            var games = [GoodGame.Game]()
            while !gamesUnkeyedContainer.isAtEnd {
                games.append(try gamesUnkeyedContainer.decode(GoodGame.Game.self))
            }
            self.games = games
            
            var genresUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .genres)
            var genres = [GoodGame.Genre]()
            while !genresUnkeyedContainer.isAtEnd {
                genres.append(try genresUnkeyedContainer.decode(GoodGame.Genre.self))
            }
            self.genres = genres
        }
    }
    
    struct Genre: Decodable {
        let title: String
        let ru: String
        let cover: String
    }
}
