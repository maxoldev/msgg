//
//  Router.swift
//  MSGG
//
//  Created by Maxim Solovyov on 18/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class Router {
    
    fileprivate var tabBarController: UITabBarController {
        return UIApplication.shared.keyWindow!.rootViewController as! UITabBarController
    }
    
    func openFavoriteStream(_ stream: Stream) {
        tabBarController.selectedIndex = 1
        guard let nc = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
        let vc = SharedComponents.vcFactory.create(.stream) as StreamVC
        vc.stream = stream
        if tabBarController.presentedViewController != nil {
            tabBarController.dismiss(animated: false, completion: nil)
        }
        nc.setViewControllers([nc.viewControllers.first!], animated: true)
        tabBarController.present(vc, animated: false, completion: nil)
    }
    
    func openViewControllerModally(_ vc: UIViewController) {
        tabBarController.present(vc, animated: true, completion: nil)
    }

    func pushViewController(_ vc: UIViewController, previous: UIViewController) {
        previous.navigationController?.pushViewController(vc, animated: true)
    }

    func openViewController(_ vc: UIViewController, insteadOfViewController currentVC: UIViewController) {
        currentVC.dismiss(animated: false) {
            let nc = self.tabBarController.selectedViewController! as! UINavigationController
            var viewControllersArray = nc.viewControllers
            viewControllersArray = [viewControllersArray.first!, vc]
            nc.setViewControllers(viewControllersArray, animated: true)
        }
    }
    
    func backToPreviousViewController(from vc: UIViewController) {
//        vc.navigationController?.popViewController(animated: true)
        vc.dismiss(animated: true, completion: nil)
    }
}
