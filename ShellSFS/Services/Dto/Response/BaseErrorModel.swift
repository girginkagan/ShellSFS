//
//  BaseErrorModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Foundation

public struct BaseErrorModel: Codable, Identifiable {
    public var id: String?
    public var errorCode: Int?
    public let message: String?
    public let errors: [ErrorData]?
    
    public init(errorCode: Int?, message: String?, errors: [ErrorData]?) {
        self.id = UUID().uuidString
        self.message = message
        self.errors = errors
        self.errorCode = errorCode
    }
}

public struct ErrorData: Codable {
    public let field, message: String?
    
    public init(field: String?, message: String?) {
        self.field = field
        self.message = message
    }
}
