//
//  StreamQuality.swift
//  MSGGCore
//
//  Created by Maxim Solovyov on 11/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

public enum StreamQuality {
    public static let sourceID = "source"
    
    case source
    case scaled(resolution: Int)
}

extension StreamQuality {
    
    public init?(str: String) {
        if str == StreamQuality.sourceID {
            self = .source
        } else if let resolution = Int(str) {
            self = .scaled(resolution: resolution)
        } else {
            return nil
        }
    }
    
    public var key: String {
        switch self {
        case .source:
            return StreamQuality.sourceID
        case let .scaled(resolution):
            return String(resolution)
        }
    }

    public var localizedTitle: String {
        switch self {
        case .source:
            return NSLocalizedString("source", comment: "")
        case let (.scaled(resolution)):
            return String(resolution)
        }
    }
}

extension StreamQuality: Equatable, Comparable {

    public static func < (lhs: StreamQuality, rhs: StreamQuality) -> Bool {
        switch (lhs, rhs) {
        case (.source, _):
            return false
        case (_, .source):
            return true
        case let (.scaled(resolution1), .scaled(resolution2)):
            return resolution1 < resolution2
        }
    }
}
