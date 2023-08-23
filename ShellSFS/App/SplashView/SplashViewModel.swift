//
//  SplashViewModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/19/23.
//

import Foundation
import Combine
import Unrealm
import RealmSwift

final class SplashViewModel {
    let realmUtil = RealmUtil()
    
    init() {
        Realm.registerRealmables(CardResponseModel.self)
    }
    
    func getCards(completion: @escaping (_ data: Bool) -> Void) {
        //realmUtil.setCard(data: CardResponseModel(id: "3", cardNumber: "783926323", cardUser: "Luke Combs", cardCompany: "futureworks", isSelected: false))
        DataProvider.shared.cards.send(realmUtil.getCards())
        completion(true)
    }
}
