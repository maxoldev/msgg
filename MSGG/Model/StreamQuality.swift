//
//  StreamQuality.swift
//  MSGG
//
//  Created by Maxim Solovyov on 11/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

enum StreamQuality: CaseIterable {
    
    case source
    case _720
    case _480
    case _240
}

extension StreamQuality {
    
    var urlSuffix: String {
        switch self {
        case .source:
            return ""
        case ._720:
            return "_720"
        case ._480:
            return "_480"
        case ._240:
            return "_240"
        }
    }

    var title: String {
        switch self {
        case .source:
            return "Source"
        case ._720:
            return "720p"
        case ._480:
            return "480p"
        case ._240:
            return "240p"
        }
    }
}
