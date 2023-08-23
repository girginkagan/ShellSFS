//
//  AddCardViewModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Foundation
import Combine

final class AddCardViewModel: ObservableObject {
    let realmUtil = RealmUtil()
    @Published var isAlert: BaseErrorModel?
    
    func addCard(card: CardResponseModel) {
        realmUtil.setCard(data: card, isSingle: true)
    }
}
