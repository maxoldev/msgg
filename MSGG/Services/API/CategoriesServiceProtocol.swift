//
//  CategoriesServiceProtocol.swift
//  MSGG
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

protocol CategoriesServiceProtocol {
    
    func getCategories(completion: @escaping ([Game], [Genre], Error?) -> ())
    func getGameInfo(gameID: String, completion: @escaping (Game?, Error?) -> ())
}
