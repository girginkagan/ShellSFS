//
//  TokenResponseModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Foundation

struct TokenResponseModel: Codable {
    var cardNumber, dntCaptchaText, dntCaptchaToken, dntCaptchaInput: String?
    
    enum CodingKeys: String, CodingKey {
        case dntCaptchaText = "DNTCaptchaText"
        case dntCaptchaToken = "DNTCaptchaToken"
        case dntCaptchaInput = "DNTCaptchaInputText"
        case cardNumber = "cardNumber_bq"
    }
}
