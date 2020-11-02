//
//  Day22VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 01/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day22VC: AoCVC, AdventDay {
    struct Constants {
        static let shieldDuration = 6
        static let poisonDuration = 6
        static let rechargeDuration = 5
        
        static let shieldBonus = 7
        static let drainDamage = 2
        static let drainHeal = 2
        static let rechargeAmount = 101
        static let poisonDamage = 3
        static let magicMissileDamage = 4
        
    }
    class Entity {
        let maxHealth: Int
        var currHealth: Int
        let defaultMana: Int
        var currMana: Int
        let damage: Int
        var armor: Int
        
        var rechargeDuration: Int = 0
        var shieldDuration: Int = 0
        var poisonDuration: Int = 0
        
        func reset() {
            self.currHealth = self.maxHealth
            self.currMana = self.defaultMana
            self.rechargeDuration = 0
            self.shieldDuration = 0
            self.poisonDuration = 0
            self.armor = 0
        }
        
        var isDead: Bool {
            return self.currHealth <= 0
        }
        
        init(health: Int, damage: Int, armor: Int, mana: Int) {
            self.maxHealth = health
            self.currHealth = health
            self.defaultMana = mana
            self.currMana = mana
            self.damage = damage
            self.armor = armor
        }
        
        func tickEffects() {
            if self.rechargeDuration > 0 {
                self.currMana += Constants.rechargeAmount
                self.rechargeDuration -= 1
            }
            if self.poisonDuration > 0 {
                self.currHealth -= Constants.poisonDamage
                self.poisonDuration -= 1
            }
            if self.shieldDuration > 0 {
                self.shieldDuration -= 1
                if shieldDuration == 0 {
                    self.armor -= Constants.shieldBonus
                }
            }
        }
        
        func heal(amount: Int) {
            self.currHealth = (self.currHealth + amount).clamp(max: self.maxHealth)
        }
        
        func takeDamage(from other: Entity) {
            self.takeDamage(amount: other.damage)
        }
        
        func takeDamage(amount: Int) {
            let damageAmount = (amount - self.armor).clamp(min: 1)
            self.currHealth -= damageAmount
        }
    }
    
    enum Spell: CaseIterable {
        case magicMissile
        case drain
        case shield
        case poison
        case recharge
        
        var manaCost: Int {
            switch self {
            case .magicMissile:
                return 53
            case .drain:
                return 73
            case .shield:
                return 113
            case .poison:
                return 173
            case .recharge:
                return 229
            }
        }
    }
    
    class Player: Entity {
        var manaSpent: Int = 0
        var currentTarget: Boss!
        
        override func reset() {
            self.manaSpent = 0
            super.reset()
        }
        
        func canAfford(spell: Spell) -> Bool {
            return self.currMana >= spell.manaCost
        }
        
        func canAffordSomeSpell() -> Bool {
            for spell in Spell.allCases {
                if self.canAfford(spell: spell) {
                    return true
                }
            }
            return false
        }
        
        func cast(spell: Spell) {
            guard self.canAfford(spell: spell) else { fatalError("Attempting to cast spell with too high cost") }
            self.currMana -= spell.manaCost
            self.manaSpent += spell.manaCost
            switch spell {
            case .magicMissile:
                self.currentTarget.takeDamage(amount: Constants.magicMissileDamage)
            case .drain:
                self.currentTarget.takeDamage(amount: Constants.drainDamage)
                self.heal(amount: Constants.drainHeal)
            case .shield:
                self.armor += Constants.shieldBonus
                self.shieldDuration = Constants.shieldDuration
            case .poison:
                self.currentTarget.poisonDuration = Constants.poisonDuration
            case .recharge:
                self.rechargeDuration = Constants.rechargeDuration
            }
        }
        
        func takeTurn() -> Bool {
            let validSpells = self.getValidSpells(against: self.currentTarget)
            guard let randomSpell = validSpells.randomElement() else { return false }
            self.cast(spell: randomSpell)
            
            return true
        }
        
        private func getValidSpells(against entity: Entity) -> [Spell] {
            return Spell.allCases.filter { (spell) -> Bool in
                let canAfford = self.canAfford(spell: spell)
                let effectActive = self.isEffectActive(spell: spell, against: entity)
                return canAfford && !effectActive
            }
        }
        
        private func isEffectActive(spell: Spell, against entity: Entity) -> Bool {
            switch spell {
            case .drain, .magicMissile:
                return false
            case .poison:
                return entity.poisonDuration > 0
            case .recharge:
                return self.rechargeDuration > 0
            case .shield:
                return self.shieldDuration > 0
            }
        }
    }
    
    class Boss: Entity {
        func attack(other: Entity) {
            other.takeDamage(amount: self.damage)
        }
    }
    
    // Silly brute-force with random.
    func solveFirst() {
        let player = Player(health: 50, damage: 0, armor: 0, mana: 500)
        let boss = Boss(health: 71, damage: 10, armor: 0, mana: 0) // From input
        player.currentTarget = boss
        
        var leastManaToWin = Int.max
        for _ in 0...1000000 {
            let playerWins = self.doesPlayerWinFight(between: player, and: boss, hardMode: false)
            if playerWins {
                leastManaToWin = min(leastManaToWin, player.manaSpent)
            }
        }
        
        self.setSolution(challenge: 0, text: "\(leastManaToWin)")
    }
    
    func solveSecond() {
        let player = Player(health: 50, damage: 0, armor: 0, mana: 500)
        let boss = Boss(health: 71, damage: 10, armor: 0, mana: 0) // From input
        player.currentTarget = boss
        
        var leastManaToWin = Int.max
        for _ in 0...10000000 {
            let playerWins = self.doesPlayerWinFight(between: player, and: boss, hardMode: true)
            if playerWins {
                leastManaToWin = min(leastManaToWin, player.manaSpent)
            }
        }
        
        self.setSolution(challenge: 1, text: "\(leastManaToWin)")
    }
    
    private func doesPlayerWinFight(between player: Player, and boss: Boss, hardMode: Bool) -> Bool {
        player.reset()
        boss.reset()
        
        assert(!player.isDead && !boss.isDead)
        
        var isPlayerTurn = true
        while !player.isDead && !boss.isDead {
            if hardMode && isPlayerTurn {
                player.takeDamage(amount: 1)
            }
            player.tickEffects()
            boss.tickEffects()
            
            guard !player.isDead && !boss.isDead else {
                break
            }
            if isPlayerTurn {
                guard player.takeTurn() else { return false }
            } else {
                boss.attack(other: player)
            }
            isPlayerTurn.toggle()
        }
        
        return !player.isDead
    }
}

extension Day22VC: TestableDay {
    func runTests() {
        self.testFight1()
        self.testFight2()
    }
    
    private func testFight1() {
        let player = Player(health: 10, damage: 0, armor: 0, mana: 250)
        let boss = Boss(health: 13, damage: 8, armor: 0, mana: 0)
        let entities = [player, boss]
        
        player.currentTarget = boss
        
        // Player
        assert(!player.isDead && !boss.isDead)
        assert(player.currHealth == 10 && player.armor == 0 && player.currMana == 250)
        assert(boss.currHealth == 13)
        entities.forEach({$0.tickEffects()})
        player.cast(spell: .poison)
        assert(boss.poisonDuration == Constants.poisonDuration)
        
        // Boss
        assert(!player.isDead && !boss.isDead)
        assert(player.currHealth == 10 && player.armor == 0 && player.currMana == 77)
        assert(boss.currHealth == 13)
        entities.forEach({$0.tickEffects()})
        assert(boss.currHealth == 10)
        assert(boss.poisonDuration == 5)
        boss.attack(other: player)
        
        // Player
        assert(!player.isDead && !boss.isDead)
        assert(player.currHealth == 2 && player.armor == 0 && player.currMana == 77)
        assert(boss.currHealth == 10)
        entities.forEach({$0.tickEffects()})
        assert(boss.currHealth == 7)
        assert(boss.poisonDuration == 4)
        player.cast(spell: .magicMissile)
        
        // Boss
        assert(!player.isDead && !boss.isDead)
        assert(player.currHealth == 2 && player.armor == 0 && player.currMana == 24)
        assert(boss.currHealth == 3)
        entities.forEach({$0.tickEffects()})
        assert(!player.isDead && boss.isDead)
    }
    
    private func testFight2() {
        let player = Player(health: 10, damage: 0, armor: 0, mana: 250)
        let boss = Boss(health: 14, damage: 8, armor: 0, mana: 0)
        let entities = [player, boss]
        
        player.currentTarget = boss
        
        // Pre-fight
        assert(!player.isDead && !boss.isDead)
        
        // Player
        assert(player.currHealth == 10 && player.armor == 0 && player.currMana == 250)
        assert(boss.currHealth == 14)
        entities.forEach({$0.tickEffects()})
        player.cast(spell: .recharge)
        assert(player.rechargeDuration == Constants.rechargeDuration)
        
        // Boss
        assert(player.currHealth == 10 && player.armor == 0 && player.currMana == 21)
        assert(boss.currHealth == 14)
        entities.forEach({$0.tickEffects()})
        assert(player.rechargeDuration == 4)
        boss.attack(other: player)
        
        // Player
        assert(player.currHealth == 2 && player.armor == 0 && player.currMana == 122)
        assert(boss.currHealth == 14)
        entities.forEach({$0.tickEffects()})
        assert(player.rechargeDuration == 3)
        player.cast(spell: .shield)
        assert(player.shieldDuration == Constants.shieldDuration)
        
        // Boss
        assert(player.currHealth == 2 && player.armor == 7 && player.currMana == 110)
        assert(boss.currHealth == 14)
        entities.forEach({$0.tickEffects()})
        assert(player.shieldDuration == 5)
        assert(player.rechargeDuration == 2)
        boss.attack(other: player)
        
        // Player
        assert(player.currHealth == 1 && player.armor == 7 && player.currMana == 211)
        assert(boss.currHealth == 14)
        entities.forEach({$0.tickEffects()})
        assert(player.shieldDuration == 4)
        assert(player.rechargeDuration == 1)
        player.cast(spell: .drain)
        
        // Boss
        assert(player.currHealth == 3 && player.armor == 7 && player.currMana == 239)
        assert(boss.currHealth == 12)
        entities.forEach({$0.tickEffects()})
        assert(player.shieldDuration == 3)
        assert(player.rechargeDuration == 0)
        boss.attack(other: player)
        
        // Player
        assert(player.currHealth == 2 && player.armor == 7 && player.currMana == 340)
        assert(boss.currHealth == 12)
        entities.forEach({$0.tickEffects()})
        assert(player.shieldDuration == 2)
        assert(player.rechargeDuration == 0)
        player.cast(spell: .poison)
        assert(boss.poisonDuration == Constants.poisonDuration)
        
        // Boss
        assert(player.currHealth == 2 && player.armor == 7 && player.currMana == 167)
        assert(boss.currHealth == 12)
        entities.forEach({$0.tickEffects()})
        assert(player.shieldDuration == 1)
        assert(boss.poisonDuration == 5)
        boss.attack(other: player)
        
        // Player
        assert(player.currHealth == 1 && player.armor == 7 && player.currMana == 167)
        assert(boss.currHealth == 9)
        entities.forEach({$0.tickEffects()})
        assert(player.shieldDuration == 0)
        assert(player.armor == 0)
        assert(boss.poisonDuration == 4)
        player.cast(spell: .magicMissile)
        
        assert(!player.isDead && !boss.isDead)
        
        // Boss
        assert(player.currHealth == 1 && player.armor == 0 && player.currMana == 114)
        assert(boss.currHealth == 2)
        entities.forEach({$0.tickEffects()})
        assert(!player.isDead && boss.isDead)
    }
}
