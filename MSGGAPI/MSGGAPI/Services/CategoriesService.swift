//
//  CategoriesService.swift
//  MSGGAPI
//
//  Created by Maxim Solovyov on 13/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore

public class CategoriesService: BaseAPIService, CategoriesServiceProtocol {
    
    public func getCategories(completion: @escaping (Result<(games: [Game], genres: [Genre]), Error>) -> ()) {
        let request = makeURLRequest4(endpoint: .games)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let foundError = self.getError(data: data, urlResponse: response, error: error) {
                Logger.error("🌐", foundError)
                completion(.failure(foundError))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggCategories = try jsonDecoder.decode(GoodGame.Categories.self, from: data!)
                let games = ggCategories.games.map({Game(goodgameGame: $0)})
                let genres = ggCategories.genres.map({Genre(goodgameGenre: $0)})
                completion(.success((games, genres)))
            } catch {
                Logger.error("🛄", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func getGameInfo(gameID: String, completion: @escaping (Result<Game, Error>) -> ()) {
        let request = makeURLRequest4(endpoint: .games, ID: gameID)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let foundError = self.getError(data: data, urlResponse: response, error: error) {
                Logger.error("🌐", foundError)
                completion(.failure(foundError))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let ggGame = try jsonDecoder.decode(GoodGame.Game.self, from: data!)
                let game = Game(goodgameGame: ggGame)
                completion(.success(game))
            } catch {
                Logger.error("🛄", error)
                completion(.failure(error))
            }
        }.resume()
    }
}
