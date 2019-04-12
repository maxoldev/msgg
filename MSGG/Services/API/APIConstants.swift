//
//  APIConstants.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

struct APIConstants {
    
    static let baseAPIUrl = "https://api2.goodgame.ru/v2/"
    static let baseVideoURL = "https://hls.goodgame.ru/hls/%@.m3u8"
}

enum APIEndpoint: String {
    case streams
    case player
}
