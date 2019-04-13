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
        let streams: [FailableDecodable<GoodGame.Stream>]
    }
    
    struct Stream: Decodable {
        let id: Int
        let title: String
        let streamer: String?
        let avatar: String
        let game: String?
        let viewers: Int
        let preview: String
        let poster: String
        let streamkey: String
        let channelkey: String
        let sources: Dictionary<String, String>
    }
    
    struct StreamOld: Decodable {
        let viewers: String
    }
    
    struct GameShort: Decodable {
        let title: String?
        let url: String?
    }
    
    struct Game: Decodable {
        let id: Int
        let url: String
        let title: String?
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
