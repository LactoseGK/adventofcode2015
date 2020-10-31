//
//  Day16VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 30/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day16VC: AoCVC, AdventDay, InputLoadable {
    private typealias Belongings = [String : Int] //Name --> Amount
    private typealias IntPredicate = (Int, Int) -> Bool
    private typealias MeasureAdjustments = [String : IntPredicate]
    private struct Sue {
        let id: Int
        let belongings: Belongings
        
        func potentiallyMatches(otherSue: Sue, adjustments: MeasureAdjustments = [:]) -> Bool {
            for key in self.belongings.keys {
                let selfCount = self.belongings[key]!
                if let otherCount = otherSue.belongings[key] {
                    let predicate = adjustments[key] ?? (==)
                    if predicate(otherCount, selfCount) == false {
                        return false
                    }
                }
            }
            return true
        }
        
        static func from(string: String) -> Sue {
            let split = string
                .replacingOccurrences(of: ":", with: "")
                .replacingOccurrences(of: ",", with: "")
                .split(separator: " ")
                .map({String($0)})
            let id = Int(split[1])!
            var belongings: Belongings = [:]
            for i in stride(from: 2, to: split.count, by: 2) {
                let name = split[i]
                let amount = Int(split[i + 1])!
                belongings[name] = amount
            }
            return Sue(id: id, belongings: belongings)
        }
    }
    
    
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    private var knownBelongings: Belongings {
        return ["children": 3,
                "cats": 7,
                "samoyeds": 2,
                "pomeranians": 3,
                "akitas": 0,
                "vizslas": 0,
                "goldfish": 5,
                "trees": 3,
                "cars": 2,
                "perfumes": 1]
    }
    
    func solveFirst() {
        let giftSue = Sue(id: -1, belongings: self.knownBelongings)
        
        let otherSues = input.map({Sue.from(string: $0)})
        let possibleMatches = otherSues.filter({giftSue.potentiallyMatches(otherSue: $0)})
        self.setSolution(challenge: 0, text: "\(possibleMatches.first!.id)")
    }
    
    func solveSecond() {
        let giftSue = Sue(id: -1, belongings: self.knownBelongings)
        
        let otherSues = input.map({Sue.from(string: $0)})
        let adjustments: MeasureAdjustments = ["cats": (>),
                                               "trees": (>),
                                               "pomeranians": (<),
                                               "goldfish": (<)]
        let possibleMatches = otherSues.filter({giftSue.potentiallyMatches(otherSue: $0, adjustments: adjustments)})
        self.setSolution(challenge: 1, text: "\(possibleMatches.first!.id)")
    }
}
