//
//  Genre.swift
//  MSGGCore
//
//  Created by Maxim Solovyov on 21/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

public struct Genre {
    
    public let enTitle: String
    public let ruTitle: String
    public let coverURL: String
    
    public init(enTitle: String, ruTitle: String, coverURL: String) {
        self.enTitle = enTitle
        self.ruTitle = ruTitle
        self.coverURL = coverURL
    }
    
    public var localizedTitle: String {
        let title = Locale.current.languageCode == "ru" ? ruTitle : enTitle
        return title
    }
}
