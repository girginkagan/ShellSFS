//
//  CardDetailResponseModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import Foundation

struct CardDetailResponseModel: Codable {
    let balanceAmount: Double?
    let cardStatusName: String?
    let message: String?
}
