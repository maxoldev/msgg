//
//  CategoriesServiceProtocol.swift
//  MSGGAPI
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation
import MSGGCore

public protocol CategoriesServiceProtocol {
    
    func getCategories(completion: @escaping (Result<(games: [Game], genres: [Genre]), Error>) -> ())
    func getGameInfo(gameID: String, completion: @escaping (Result<Game, Error>) -> ())
}
