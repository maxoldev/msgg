//
//  CategoriesService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class CategoriesService: BaseAPIService {
    
    func getCategories(completion: @escaping ([Game], [Genre], Error?) -> ()) {
        let request = makeURLRequest4(endpoint: .games)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                completion([], [], foundError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggCategories = try jsonDecoder.decode(GoodGame.Categories.self, from: data!)
                let games = ggCategories.games.map({Game(goodgameGame: $0)})
                let genres = ggCategories.genres.map({Genre(goodgameGenre: $0)})
                completion(games, genres, nil)
            } catch {
                print(error)
                completion([], [], error)
            }
        }.resume()
    }
    
    func getGameInfo(gameID: String, completion: @escaping (Game?, Error?) -> ()) {
        let request = makeURLRequest4(endpoint: .games, ID: gameID)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            let foundError = self.getError(data: data, urlResponse: response, error: error)
            guard foundError == nil else {
                completion(nil, foundError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggGame = try jsonDecoder.decode(GoodGame.Game.self, from: data!)
                let game = Game(goodgameGame: ggGame)
                completion(game, nil)
            } catch {
                print(error)
                completion(nil, error)
            }
        }.resume()
    }
}
