//
//  GameListRouter.swift
//  MSGG
//
//  Created by Maxim Solovyov on 20/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

protocol GameListRouterProtocol {
    
    func didSelectGame(_ game: Game)
}

class GameListRouter: BaseRouter, GameListRouterProtocol {
    
    func didSelectGame(_ game: Game) {
        let vc = DepedencyContainer.global.resolve(VCFactory.self)!.create(.streamList) as StreamListVC
        vc.context = .game(game)
        openViewControllerModally(UINavigationController(rootViewController: vc))
    }
}
