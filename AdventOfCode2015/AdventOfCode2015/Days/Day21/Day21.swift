//
//  Day21.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 31/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day21VC: AoCVC, AdventDay, InputLoadable {
    class Entity {
        let maxHealth: Int
        var health: Int
        let damage: Int
        let armor: Int
        
        func reset() {
            self.health = maxHealth
        }
        
        var isDead: Bool {
            return self.health <= 0
        }
        
        init(health: Int, damage: Int, armor: Int) {
            self.maxHealth = health
            self.health = health
            self.damage = damage
            self.armor = armor
        }
        
        func takeDamage(from other: Entity) {
            let damageTaken = (other.damage - self.armor).clamp(min: 1)
            self.health -= damageTaken
        }
    }
    
    class Player: Entity {
        let equipmentCost: Int
        
        init(health: Int, damage: Int, armor: Int, equipmentCost: Int) {
            self.equipmentCost = equipmentCost
            super.init(health: health, damage: damage, armor: armor)
        }
    }
    class Boss: Entity {}
    
    struct Equipment {
        let name: String
        let cost: Int
        let damage: Int
        let armor: Int
        
        static func from(string: String) -> Equipment {
            let components = string.components(separatedBy: "  ").filter({!$0.isEmpty}).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
            return Equipment(name: components[0],
                             cost: components[1].intValue!,
                             damage: components[2].intValue!,
                             armor: components[3].intValue!)
        }
    }
    
    private var weapons: [Equipment] = []
    private var armor: [Equipment] = []
    private var rings: [Equipment] = []
    
    func loadInput() {
        self.loadEquipment()
    }
    
    private func loadEquipment() {
        let weapons = """
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0
"""
        let armor = """
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5
"""
        let rings = """
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3
"""
        
        self.weapons = weapons.components(separatedBy: "\n").map(Equipment.from)
        self.armor = armor.components(separatedBy: "\n").map(Equipment.from)
        self.rings = rings.components(separatedBy: "\n").map(Equipment.from)
        
        // Simulates unequipped item.
        self.armor.append(Equipment(name: "No Armor", cost: 0, damage: 0, armor: 0))
        self.rings.append(Equipment(name: "No Ring 1", cost: 0, damage: 0, armor: 0))
        self.rings.append(Equipment(name: "No Ring 2", cost: 0, damage: 0, armor: 0))
    }
    
    func solveFirst() {
        let players =  self.generatePlayerPermutations().sorted(by: {$0.equipmentCost < $1.equipmentCost})
        let boss = Boss(health: 100, damage: 8, armor: 2) // From input
        let cheapest = players
            .filter({self.doesPlayerWinBattle(player: $0, boss: boss)})
            .min(by: {$0.equipmentCost < $1.equipmentCost})!
        self.setSolution(challenge: 0, text: "\(cheapest.equipmentCost)")
    }
    
    func solveSecond() {
        let players =  self.generatePlayerPermutations().sorted(by: {$0.equipmentCost < $1.equipmentCost})
        let boss = Boss(health: 100, damage: 8, armor: 2) // From input
        let mostExpensive = players
            .filter({!self.doesPlayerWinBattle(player: $0, boss: boss)})
            .max(by: {$0.equipmentCost < $1.equipmentCost})!
        self.setSolution(challenge: 1, text: "\(mostExpensive.equipmentCost)")
    }
    
    private func generatePlayerPermutations() -> [Player] {
        let weaponCombinations = PermutationHelper.allCombinations(self.weapons).filter({$0.count == 1}).map({$0.first!})
        let armorCombinations = PermutationHelper.allCombinations(self.armor).filter({$0.count == 1}).map({$0.first!})
        let ringCombinations = PermutationHelper.allCombinations(self.rings).filter({$0.count == 2})
        
        var validPlayers: [Player] = []
        for weaponChoice in weaponCombinations {
            for armorChoice in armorCombinations {
                for ringChoice in ringCombinations {
                    let loadout = [weaponChoice, armorChoice] + ringChoice
                    let damage = loadout.map({$0.damage}).reduce(0, +)
                    let armor = loadout.map({$0.armor}).reduce(0, +)
                    let cost = loadout.map({$0.cost}).reduce(0, +)
                    
                    validPlayers.append(Player(health: 100, damage: damage, armor: armor, equipmentCost: cost))
                }
            }
        }
        return validPlayers
    }
    
    // Since damage + armor is static, could also just math it out.
    private func doesPlayerWinBattle(player: Player, boss: Boss) -> Bool {
        boss.reset()
        while true {
            boss.takeDamage(from: player)
            if boss.isDead {
                return true
            }
            
            player.takeDamage(from: boss)
            if player.isDead {
                return false
            }
        }
    }
}

extension Day21VC: TestableDay {
    func runTests() {
        let player = Player(health: 8, damage: 5, armor: 5, equipmentCost: 0)
        let boss = Boss(health: 12, damage: 7, armor: 2)
        
        assert(self.doesPlayerWinBattle(player: player, boss: boss))
    }
}
