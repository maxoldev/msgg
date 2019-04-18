//
//  SharedComponents.swift
//  MSGG
//
//  Created by Maxim Solovyov on 10/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

struct SharedComponents {
    
    static fileprivate(set) var vcFactory: VCFactory = VCFactoryImpl()
    static fileprivate(set) var favoritesService: FavoritesService = FavoritesService(streamsService: StreamsService())
    static fileprivate(set) var settingsService: SettingsService = SettingsService()
    static fileprivate(set) var router: Router = Router()

    static func set(vcFactory: VCFactory) {
        self.vcFactory = vcFactory
    }
}
