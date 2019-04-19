//
//  UIViewController+Topmost.swift
//  MSGG
//
//  Created by Maxim Solovyov on 19/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var ms_topmostViewController: UIViewController? {
        guard var topController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
            
        return topController
    }
}
