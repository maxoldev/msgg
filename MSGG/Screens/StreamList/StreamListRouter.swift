//
//  StreamListRouter.swift
//  MSGG
//
//  Created by Maxim Solovyov on 20/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit
import MSGGCore

protocol StreamListRouterProtocol {
    
    func didSelectStream(_ stream: MSGGCore.Stream)
}

class StreamListRouter: BaseRouter, StreamListRouterProtocol {
    
    func didSelectStream(_ stream: MSGGCore.Stream) {
        let vc = DepedencyContainer.global.resolve(VCFactory.self)!.create(.stream) as StreamVC
        vc.stream = stream
        openViewControllerModally(vc)
    }
}
