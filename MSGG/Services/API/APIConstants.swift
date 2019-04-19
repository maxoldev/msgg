//
//  APIConstants.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

struct APIConstants {
    
    static let host = "goodgame.ru"
    static let baseAPIUrl = "https://api2.goodgame.ru/v2/"
    static let baseVideoURL = "https://hls.goodgame.ru/hls/%@.m3u8"
    static let baseAPIUrl4 = "https://goodgame.ru/api/4/"
    static let smilExt = "smil"
    
    static let itemLimit = 2000
}

enum APIEndpoint: String {
    case streams
    case stream
    case player
    case games
}
