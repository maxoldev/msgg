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
            UserDefaults.standard.set(lastSelectedStreamQuality.key, forKey: UserDefaultsKeys.lastSelectedStreamQuality.rawValue)
        }
    }
    
    var werePlayerControlsShown: Bool {
        didSet {
            UserDefaults.standard.set(werePlayerControlsShown, forKey: UserDefaultsKeys.wasControlsHintShown.rawValue)
        }
    }
    
    init() {
        if let string = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastSelectedStreamQuality.rawValue),
            let quality = StreamQuality.init(str: string) {
            lastSelectedStreamQuality = quality
        } else {
            lastSelectedStreamQuality = .source
        }
        
        werePlayerControlsShown = UserDefaults.standard.bool(forKey: UserDefaultsKeys.wasControlsHintShown.rawValue)
    }
}
