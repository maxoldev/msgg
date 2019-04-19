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
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
            self.tabBarController.selectedIndex = 1  // select Favorites

            let vc = SharedComponents.vcFactory.create(.stream) as StreamVC
            vc.stream = stream
            UIViewController.ms_topmostViewController?.present(vc, animated: false, completion: nil)
        })
    }
    
    func openViewControllerModally(_ vc: UIViewController) {
        UIViewController.ms_topmostViewController?.present(vc, animated: true, completion: nil)
    }

    func pushViewController(_ vc: UIViewController, previous: UIViewController) {
        previous.navigationController?.pushViewController(vc, animated: true)
    }

    func openViewController(_ vc: UIViewController, insteadOfViewController currentVC: UIViewController) {
        currentVC.dismiss(animated: false) {
            UIViewController.ms_topmostViewController?.present(vc, animated: false, completion: nil)
        }
    }
    
    func backToPreviousViewController(from vc: UIViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
