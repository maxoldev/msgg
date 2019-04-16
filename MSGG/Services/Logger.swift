//
//  Logger.swift
//  MSGG
//
//  Created by Maxim Solovyov on 16/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class Logger {
    
    static func error(_ items: Any...) {
        print("❌", terminator: " ")
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
    
    static func warning(_ items: Any...) {
        print("⚠️", terminator: " ")
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
    
    static func info(_ items: Any...) {
        print("ℹ️", terminator: " ")
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
    
    static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
}
