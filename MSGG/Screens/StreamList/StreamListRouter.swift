//
//  StreamListRouter.swift
//  MSGG
//
//  Created by Maxim Solovyov on 20/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import UIKit

protocol StreamListRouterProtocol {
    
    func didSelectStream(_ stream: Stream)
}

class StreamListRouter: BaseRouter, StreamListRouterProtocol {
    
    func didSelectStream(_ stream: Stream) {
        let vc = DepedencyContainer.global.resolve(VCFactory.self)!.create(.stream) as StreamVC
        vc.stream = stream
        openViewControllerModally(vc)
    }
}
