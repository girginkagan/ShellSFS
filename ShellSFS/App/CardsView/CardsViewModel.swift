//
//  CardsViewModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import Foundation
import Combine

final class CardsViewModel: ObservableObject {
    @Published var cards = [CardResponseModel]()
    let realmUtil = RealmUtil()
    
    func getCards() {
        cards = DataProvider.shared.cards.value
    }
    
    func onDataDelete(index: Int) {
        realmUtil.removeCard(data: DataProvider.shared.cards.value[index])
        getCards()
    }
    
    func selectCard(item: CardResponseModel) {
        var cards = realmUtil.getCards()
        for i in 0..<cards.count {
            cards[i].isSelected = item.id == cards[i].id
        }
        realmUtil.setCards(data: cards)
        getCards()
    }
}
