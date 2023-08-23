//
//  RealmUtil.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import RealmSwift
import Unrealm
import Combine

final class RealmUtil {
    private let version: UInt64 = 1
    
    init() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: version, migrationBlock: migrate)
    }
    
    private func migrate(migration: Migration, oldVersion: UInt64) {
        /*migration.enumerateObjects(ofType: Class.className()) { oldSetting, newSetting in
            migration.enumerateObjects(ofType: Class.className()) { old, new in
                if  old!["smt"] as! Int == 3 {
                    newSetting!["smt"] = old!["smt"]
                }
            }
        }*/
    }
    
    func setCards(data: [CardResponseModel]) {
        removeAllCards()
        for item in data {
            setCard(data: item)
        }
        DataProvider.shared.cards.send(data)
    }
    
    func setCard(data: CardResponseModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(data)
        }
    }
    
    func setCard(data: CardResponseModel, isSingle: Bool) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(data)
        }
        
        if isSingle {
            var cards = getCards()
            for i in 0..<cards.count {
                cards[i].isSelected = cards[i].id == data.id
            }
            setCards(data: cards)
        }
    }
    
    func getCards() -> [CardResponseModel] {
        let realm = try! Realm()
        let res = realm.objects(CardResponseModel.self)
        return Array(res)
    }
    
    func removeCard(data: CardResponseModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(data)
        }
        if data.isSelected ?? false {
            var cards = getCards()
            for i in 0..<cards.count {
                cards[i].isSelected = i == 0
            }
            setCards(data: cards)
        } else {
            DataProvider.shared.cards.send(getCards())
        }
    }
    
    func removeAllCards() {
        let realm = try! Realm()
        let allCards = realm.objects(CardResponseModel.self)
        try! realm.write {
            realm.delete(Array(allCards))
        }
        DataProvider.shared.cards.send([])
    }
}
