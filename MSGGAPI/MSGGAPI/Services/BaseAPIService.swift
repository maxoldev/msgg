//
//  BaseAPIService.swift
//  MSGGAPI
//
//  Created by Maxim Solovyov on 09/04/2019.
//  Copyright © 2019 MaximSolovyov. All rights reserved.
//

import Foundation

public class BaseAPIService {
    
    public init() {
    }
    
    func makeURLRequest(endpoint: APIEndpoint, ID: String? = nil) -> URLRequest {
        let fullEndpoint = ID != nil ? "\(endpoint.rawValue)/\(ID!)" : "\(endpoint.rawValue)"
        let urlComponents = URLComponents(string: "\(APIConstants.baseAPIUrl)\(fullEndpoint)")!
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        return request
    }
    
    func makeURLRequest4(endpoint: APIEndpoint, ID: String? = nil, queryItems: [URLQueryItem]? = nil) -> URLRequest {
        let fullEndpoint = ID != nil ? "\(endpoint.rawValue)/\(ID!)" : "\(endpoint.rawValue)"
        var urlComponents = URLComponents(string: "\(APIConstants.baseAPIUrl4)\(fullEndpoint)")!
        urlComponents.queryItems = queryItems
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        return request
    }
    
    func getError(data: Data?, urlResponse: URLResponse?, error: Error?) -> Error? {
        guard error == nil else {
            return error
        }
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return APIServiceError(code: .notHttpResponse)
        }
        
        guard data != nil else {
            return APIServiceError(code: .nilHttpBody)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            return APIServiceError(code: .statusCode, description: "Error http status code: \(httpResponse.statusCode)")
        }
        
        return nil
    }
}
