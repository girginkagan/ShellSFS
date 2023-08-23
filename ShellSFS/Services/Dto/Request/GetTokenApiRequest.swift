//
//  GetTokenApiRequest.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Foundation

final class GetTokenApiRequest: BaseRequest {
    var headers: [String: String]?
    var requestBodyObject: Data?
    var requestMethod = RequestHttpMethod.get
    var requestPath: String = "bakiye-sorgula"
}
