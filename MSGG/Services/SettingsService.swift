//
//  SettingsService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 20/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

protocol SettingsService: class {
    
    var lastSelectedStreamQuality: StreamQuality { get set }
    var werePlayerControlsShown: Bool { get set }
}
