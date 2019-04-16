//
//  APIServiceError.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class APIServiceError: NSError {
    
    enum Code: Int {
        case common             = 0
        case statusCode         = 1
        case nilHttpBody        = 100
        case notHttpResponse    = 101
    }
    
    init(code: Code, description: String? = nil) {
        let domain = type(of: self)
        var userInfo = [NSLocalizedFailureReasonErrorKey: "\(code)"]
        if let description = description {
            userInfo[NSLocalizedDescriptionKey] = description
        }
        super.init(domain: String(describing: domain), code: code.rawValue, userInfo: userInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
