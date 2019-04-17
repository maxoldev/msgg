//
//  CustomTabBar.swift
//  MSGG
//
//  Created by Maxim Solovyov on 18/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {
    
    override var canBecomeFocused: Bool {
        guard super.canBecomeFocused else {
            return false
        }
        
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
            let nc = rootVC.selectedViewController as? UINavigationController else {
            return true
        }
        
        return nc.viewControllers.count == 1
    }
}
