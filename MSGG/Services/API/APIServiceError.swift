//
//  APIServiceError.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
    case notHttpResponse
    case nilHttpBody
    case error(String)
}
