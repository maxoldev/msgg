//
//  BaseAPIService.swift
//  MSGG
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

class BaseAPIService {
    
    
    func makeURLRequest(endpoint: APIEndpoint, ID: String? = nil) -> URLRequest {
        let fullEndpoint = ID != nil ? "\(endpoint.rawValue)/\(ID!)" : "\(endpoint.rawValue)"
        let urlComponents = URLComponents(string: "\(APIConstants.baseAPIUrl)\(fullEndpoint)")!
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        return request
    }
    
    func makeURLRequest4(endpoint: APIEndpoint, ID: String? = nil) -> URLRequest {
        let fullEndpoint = ID != nil ? "\(endpoint.rawValue)/\(ID!)" : "\(endpoint.rawValue)"
        let urlComponents = URLComponents(string: "\(APIConstants.baseAPIUrl4)\(fullEndpoint)")!
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        return request
    }
    
    func getError(data: Data?, urlResponse: URLResponse?, error: Error?) -> Error? {
        guard error == nil else {
            return error
        }
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return APIServiceError.notHttpResponse
        }
        
        guard let responseData = data else {
            return APIServiceError.nilHttpBody
        }
        
        guard httpResponse.statusCode == 200 else {
//            let error = self.handleErrorResponseData(responseData)
//            return error
            return APIServiceError.error("\(httpResponse.statusCode)")
        }
        
        return nil
    }
}
