//
//  Game.swift
//  MSGGCore
//
//  Created by Maxim Solovyov on 21/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

public struct Game {
    
    public let gameID: IDType
    public let url: String
    public let coverURL: String
    public let title: String
    
    public init(gameID: IDType, url: String, coverURL: String, title: String) {
        self.gameID = gameID
        self.url = url
        self.coverURL = coverURL
        self.title = title
    }
}
