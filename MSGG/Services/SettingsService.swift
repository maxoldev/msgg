//
//  SettingsService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 16/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class SettingsService {
    
    var lastSelectedStreamQuality: StreamQuality {
        didSet {
            UserDefaults.standard.set(lastSelectedStreamQuality.string, forKey: UserDefaultsKeys.lastSelectedStreamQuality.rawValue)
        }
    }
    
    init() {
        if let string = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastSelectedStreamQuality.rawValue),
            let quality = StreamQuality.init(str: string) {
            lastSelectedStreamQuality = quality
        } else {
            lastSelectedStreamQuality = .source
        }
    }
}
