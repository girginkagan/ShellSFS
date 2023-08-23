//
//  PostBalanceInquiryApiRequest.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Foundation

final class PostBalanceInquiryApiRequest: BaseRequest {
    var headers: [String: String]?
    var requestBodyObject: Data?
    var requestMethod = RequestHttpMethod.post
    var requestPath: String = "account/balanceinquiry"
    
    init(params: TokenResponseModel) {
        var data = Data()
        
        do {
            let jsonData = try JSONEncoder().encode(params)
            requestBodyObject = jsonData
        } catch {
            print(error)
        }
    }
}
