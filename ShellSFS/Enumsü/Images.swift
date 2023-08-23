//
//  Images.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/19/23.
//

import SwiftUI

enum Images: String {
    case ic_card
    case ic_tab_home
    case ic_tab_cards
    case ic_logo
    case ic_add
    
    var image: Image? {
        Image(rawValue)
    }
}
