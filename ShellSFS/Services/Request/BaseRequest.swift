//
//  BaseRequest.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Foundation
import Alamofire

public protocol BaseRequest {
    var requestMethod: RequestHttpMethod { get }
    var headers: [String: String]? { get }
    var requestBodyObject: Data? { get }
    var requestPath: String { get }
    func request() -> URLRequest
}

extension BaseRequest {
    var enviroment: Environment {
#if DEV
        return Environment.dev
#elseif PROD
        return Environment.prod
#else
        return Environment.prod
#endif
    }

    public func request() -> URLRequest {
        let url: URL! = URL(string: baseUrl + requestPath)
        var request = URLRequest(url: url)
        
        if let headers = headers {
            for headerKey in headers.keys {
                request.setValue(headers[headerKey], forHTTPHeaderField: headerKey)
            }
        }
        
        request.setValue("PostmanRuntime/7.28.4", forHTTPHeaderField: "User-Agent")
        
        switch requestMethod {
        case .get:
            request.httpMethod = "GET"
        case .post:
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = requestBodyObject
        case .put:
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            request.httpBody = requestBodyObject
        case .delete:
            request.httpMethod = "DELETE"
        default:
            request.httpMethod = "GET"
        }
        
        return request
    }
    
    var baseUrl: String {
        switch enviroment {
        case .prod:
            return "https://sfs.turkiyeshell.com/"
        case .dev:
            return "https://sfs.turkiyeshell.com/"
        }
    }
}

public enum RequestHttpMethod {
    case get
    case post
    case patch
    case delete
    case put
}

public enum Environment {
    case prod
    case dev
}
