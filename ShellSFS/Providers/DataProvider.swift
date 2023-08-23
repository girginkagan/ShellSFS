//
//  DataProvider.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import Foundation
import Combine

final class DataProvider {
    var cancellables = Set<AnyCancellable>()
    let cards = CurrentValueSubject<[CardResponseModel], Never>([])
    
    static let shared = DataProvider()
}
