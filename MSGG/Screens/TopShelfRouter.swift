//
//  TopShelfRouter.swift
//  MSGG
//
//  Created by Maxim Solovyov on 20/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import MSGGCore

protocol TopShelfRouterProtocol {
    
    func didSelectInTopShelf(stream: MSGGCore.Stream)
}

class TopShelfRouter: BaseRouter, TopShelfRouterProtocol {
    
    func didSelectInTopShelf(stream: MSGGCore.Stream) {
        let openStream = {
//            self.tabBarController.selectedIndex = 1  // select Favorites
            let vc = DepedencyContainer.global.resolve(VCFactory.self)!.create(.stream) as StreamVC
            vc.stream = stream
            self.openViewControllerModally(vc)
        }
        let rootvc = UIApplication.shared.keyWindow?.rootViewController
        if rootvc?.presentedViewController != nil {
            rootvc?.dismiss(animated: false, completion: {
                openStream()
            })
        } else {
            openStream()
        }
    }
}
