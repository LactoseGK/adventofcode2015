//
//  Day13VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 29/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day13VC: AoCVC, AdventDay, InputLoadable {
    private var input: [String] = []
    
    private var happinessMap: [String : Int] = [:] //Name-Name --> Happiness
    private var guestList: Set<String> = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
    }
    
    private func reset() {
        self.happinessMap = [:]
        self.guestList = []
    }
    
    private func updateGuestInfo(from string: String) {
        let split = string.split(separator: " ")
        let main = String(split[0])
        let other = String(split[10]).replacingOccurrences(of: ".", with: "")
        let gain = String(split[2]) == "gain"
        let happinessDelta = Int(split[3])! * (gain ? 1 : -1)
        
        let key = "\(main)-\(other)"
        self.happinessMap[key] = happinessDelta
        self.guestList.insert(main)
        self.guestList.insert(other)
    }
    
    private func calculateTotalHappiness(for permutation: [String]) -> Int {
        var happiness = 0
        for (index, main) in permutation.enumerated() {
            let prevOtherIndex = (index + permutation.count - 1) % permutation.count
            let nextOtherIndex = (index + 1) % permutation.count
            
            let prevOtherName = permutation[prevOtherIndex]
            let nextOtherName = permutation[nextOtherIndex]
            
            let prevKey = "\(main)-\(prevOtherName)"
            happiness += self.happinessMap[prevKey]!
            let nextKey = "\(main)-\(nextOtherName)"
            happiness += self.happinessMap[nextKey]!
        }
        
        return happiness
    }
    
    func solveFirst() {
        self.reset()
        self.input.forEach({self.updateGuestInfo(from: $0)})
        let allPermutations = PermutationHelper.allPermutations(Array(self.guestList))
        let result = allPermutations.map({self.calculateTotalHappiness(for: $0)}).max()!
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        self.reset()
        self.input.forEach({self.updateGuestInfo(from: $0)})
        self.addSelf()
        let allPermutations = PermutationHelper.allPermutations(Array(self.guestList))
        let result = allPermutations.map({self.calculateTotalHappiness(for: $0)}).max()!
        self.setSolution(challenge: 1, text: "\(result)")
    }
    
    private func addSelf() {
        for member in self.guestList {
            let selfKey = "Self-\(member)"
            let memberKey = "\(member)-Self"
            self.happinessMap[selfKey] = 0
            self.happinessMap[memberKey] = 0
        }
        self.guestList.insert("Self")
    }
}

extension Day13VC: TestableDay {
        func runTests() {
            let testInput = """
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
    """
                .split(separator: "\n").map({String($0)})
            
            testInput.forEach({self.updateGuestInfo(from: $0)})
            let allPermutations = PermutationHelper.allPermutations(Array(self.guestList))
            let testResult = allPermutations.map({self.calculateTotalHappiness(for: $0)}).max()!
            
            assert(testResult == 330)
            
            self.reset()
        }
}
