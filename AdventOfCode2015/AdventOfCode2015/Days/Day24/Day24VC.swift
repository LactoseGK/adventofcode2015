//
//  Day24VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 02/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day24VC: AoCVC, AdventDay, InputLoadable {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    func solveFirst() {
        let numbers = Set(self.input.map({$0.intValue!}))
        let solution = self.solve2(input: numbers, numSplits: 3)
        self.setSolution(challenge: 0, text: "\(solution)")
    }
    
    func solveSecond() {
        let numbers = Set(self.input.map({$0.intValue!}))
        let solution = self.solve2(input: numbers, numSplits: 4)
        self.setSolution(challenge: 1, text: "\(solution)")
    }
    
    private func solve2(input: Set<Int>, numSplits: Int) -> Int {
        let smallestValidConfigs = self.getValidConfigurations2(for: input, numSplits: numSplits)
        return self.getLowestQE(for: smallestValidConfigs)
    }
    
    // Hacky random generated brute-force.
    private func getValidConfigurations2(for input: Set<Int>, numSplits: Int) -> Set<Set<Int>> {
        var smallestSizeSets: Set<Set<Int>> = []
        let totalValue = input.reduce(0, +)
        for i in 4..<input.count - 2 {
            for _ in 0...5000000 {
                let shuffled = input.shuffled()
                let candidate = (0..<i).map({shuffled[$0]})
                let candidateValue = candidate.reduce(0, +)
                guard candidateValue * numSplits == totalValue else { continue }
                smallestSizeSets.insert(Set(candidate))
            }
            
            if !smallestSizeSets.isEmpty {
                return smallestSizeSets
            }
        }
        
        fatalError("Couldn't find any valid configurations.")
    }
    
    private func getLowestQE(for numbers: Set<Set<Int>>) -> Int {
        return numbers.map({self.getQE(for: $0)}).min(by: <)!
    }
    
    private func getQE(for numbers: Set<Int>) -> Int {
        return numbers.reduce(1, *)
    }
}
