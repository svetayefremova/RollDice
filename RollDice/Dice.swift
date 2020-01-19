//
//  Dice.swift
//  RollDice
//
//  Created by Yes on 27.12.2019.
//  Copyright © 2019 Yes. All rights reserved.
//

import Foundation


class Dice: Identifiable, Codable {
    let id = UUID()
    var result = 0
    var createdAt = ""
}

class Dices: ObservableObject {
    static let saveKey = "SavedDices"
    @Published private(set) var data: [Dice]
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ dice: Dice) {
        data.append(dice)
        save()
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Dice].self, from: data) {
                self.data = decoded
                return
            }
        }
        
        self.data = []
    }
}
