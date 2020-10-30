//
//  Day17VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 30/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day17VC: AoCVC, AdventDay {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
    }
    
    func runTests() {
        let sizes = [20, 15, 10, 5, 5]
        let storageGoal = 25
        
        let allPermutations = PermutationHelper.allCombinations(sizes)
        let results = allPermutations.map({self.doesPermutationSucceed(permutation: $0, storageGoal: storageGoal)})
        let filtered = results.filter({$0})
        assert(filtered.count == 4)
    }
    
    private func doesPermutationSucceed(permutation: [Int], storageGoal: Int) -> Bool {
        return permutation.reduce(0, +) == storageGoal
    }
    
    
    func solveFirst() {
        let storageGoal = 150
        let sizes = input.map({Int($0)!})
        let allPermutations = PermutationHelper.allCombinations(sizes)
        let results = allPermutations.map({self.doesPermutationSucceed(permutation: $0, storageGoal: storageGoal)})
        let filtered = results.filter({$0})
        self.setSolution(challenge: 0, text: "\(filtered.count)")
    }
    
    func solveSecond() {
        let storageGoal = 150
        let sizes = input.map({Int($0)!})
        let allPermutations = PermutationHelper.allCombinations(sizes)
        var solutionDictionary: [Int : Int] = [:] // Number of containers --> Number of solutions
        allPermutations.forEach { (permutation) in
            if self.doesPermutationSucceed(permutation: permutation, storageGoal: storageGoal) {
                let containerCount = permutation.count
                let existingSolutions = solutionDictionary[containerCount] ?? 0
                solutionDictionary[containerCount] = existingSolutions + 1
            }
        }
        let minimumContainerAmount = solutionDictionary.keys.min()!
        let numSolutions = solutionDictionary[minimumContainerAmount]!
        self.setSolution(challenge: 1, text: "\(numSolutions)")
    }
}
