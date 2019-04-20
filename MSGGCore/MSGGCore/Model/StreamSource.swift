//
//  StreamSource.swift
//  MSGGCore
//
//  Created by Maxim Solovyov on 16/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

public struct StreamSource {
    
    public let quality: StreamQuality
    public let url: String
    
    public init(quality: StreamQuality, url: String) {
        self.quality = quality
        self.url = url
    }
}

extension StreamSource: Comparable {
    
    public static func <(lhs: StreamSource, rhs: StreamSource) -> Bool {
        return lhs.quality < rhs.quality
    }
}
