//
//  Logger.swift
//  MSGGCore
//
//  Created by Maxim Solovyov on 16/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

public class Logger {
    
    public static func error(_ items: Any...) {
        print("❌", terminator: " ")
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
    
    public static func warning(_ items: Any...) {
        print("⚠️", terminator: " ")
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
    
    public static func info(_ items: Any...) {
        print("ℹ️", terminator: " ")
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
    
    public static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        items.enumerated().forEach({ print($1, terminator: $0 < items.count - 1 ? " " : "\n") })
    }
}
