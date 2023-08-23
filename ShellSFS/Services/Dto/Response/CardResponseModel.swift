//
//  CardResponseModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import Foundation
import Unrealm

// MARK: - CardResponseModel
struct CardResponseModel: Codable, Realmable, Identifiable {
    var id: String?
    var cardNumber, cardUser: String?
    var cardCompany: String?
    var isSelected: Bool?
    
    static func primaryKey() -> String? {
        return "id"
    }
}
