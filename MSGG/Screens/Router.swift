//
//  Router.swift
//  MSGG
//
//  Created by Maxim Solovyov on 18/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class Router {
    
    unowned let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func openFavoriteStream(_ stream: Stream) {
        tabBarController.selectedIndex = 1
        guard let nc = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
        let vc = SharedComponents.vcFactory.create(.stream) as StreamVC
        vc.stream = stream
        nc.setViewControllers([nc.viewControllers.first!, vc], animated: true)
    }
}
