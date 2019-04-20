//
//  BaseRouter.swift
//  MSGG
//
//  Created by Maxim Solovyov on 20/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class BaseRouter {
    
    func openViewControllerModally(_ vc: UIViewController) {
        UIViewController.ms_topmostViewController?.present(vc, animated: true, completion: nil)
    }
}
