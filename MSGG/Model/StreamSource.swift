//
//  StreamSource.swift
//  MSGG
//
//  Created by Maxim Solovyov on 16/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

struct StreamSource {
    let quality: StreamQuality
    let url: String
}

extension StreamSource {
    
    init?(id: String, url: String) {
        if id == StreamQuality.sourceID {
            if url.hasSuffix(APIConstants.smilExt) {
                return nil
            } else {
                self.init(quality: .source, url: url)
            }
        } else if let resolution = Int(id) {
            self.init(quality: .scaled(resolution: resolution), url: url)
        } else {
            return nil
        }
    }
    
    var title: String {
        switch quality {
        case .source:
            return NSLocalizedString("source", comment: "")
        case let (.scaled(resolution)):
            return String(resolution)
        }
    }
}

extension StreamSource: Comparable {
    
    static func <(lhs: StreamSource, rhs: StreamSource) -> Bool {
        return lhs.quality < rhs.quality
    }
}
