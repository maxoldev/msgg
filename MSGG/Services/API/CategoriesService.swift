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
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let foundError = self.getError(data: data, urlResponse: response, error: error) {
                Logger.error(foundError)
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
                Logger.error(error)
                completion([], [], error)
            }
        }.resume()
    }
    
    func getGameInfo(gameID: String, completion: @escaping (Game?, Error?) -> ()) {
        let request = makeURLRequest4(endpoint: .games, ID: gameID)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let foundError = self.getError(data: data, urlResponse: response, error: error) {
                Logger.error(foundError)
                completion(nil, foundError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggGame = try jsonDecoder.decode(GoodGame.Game.self, from: data!)
                let game = Game(goodgameGame: ggGame)
                completion(game, nil)
            } catch {
                Logger.error(error)
                completion(nil, error)
            }
        }.resume()
    }
}
