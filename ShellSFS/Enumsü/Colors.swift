//
//  Colors.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/19/23.
//

import SwiftUI
import UIKit

enum Colors: String {
    case color_bg
    case color_primary
    case color_white
    case color_green
    case color_accent
    case color_progresshud_bg
    
    var color: Color? {
        Color(rawValue)
    }
}
