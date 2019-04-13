//
//  StreamQuality.swift
//  MSGG
//
//  Created by Maxim Solovyov on 11/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

enum StreamQuality {
    case source
    case scaled(resolution: Int)
}

struct StreamSource {
    let quality: StreamQuality
    let url: String
}

extension StreamSource {
    
    var title: String {
        switch quality {
        case .source:
            return NSLocalizedString("Source", comment: "")
        case let (.scaled(resolution)):
            return String(resolution)
        }
    }
}
