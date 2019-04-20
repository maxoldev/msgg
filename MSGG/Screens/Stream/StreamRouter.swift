//
//  StreamRouter.swift
//  MSGG
//
//  Created by Maxim Solovyov on 20/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import MSGGCore

protocol StreamRouterProtocol {
    
    func didSelectGame(_ game: Game, currentVC: UIViewController)
    func didSelectBack(currentVC: UIViewController)
}

class StreamRouter: BaseRouter, StreamRouterProtocol {
    
    func didSelectGame(_ game: Game, currentVC: UIViewController) {
        let vc = DepedencyContainer.global.resolve(VCFactory.self)!.create(.streamList) as StreamListVC
        vc.context = .game(game)

        currentVC.dismiss(animated: false) {
            UIViewController.ms_topmostViewController?.present(UINavigationController(rootViewController: vc), animated: false, completion: nil)
        }
    }
    
    func didSelectBack(currentVC: UIViewController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
}
