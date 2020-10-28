//
//  Day09VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 28/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day09VC: AoCVC, AdventDay {
    
    private var input: [String] = []
    private var locations: Set<String> = []
    private var distances: [String : Int] = [:] // Loc1-Loc2 --> Distance
    
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
        self.generatePaths(from: self.input)
//        self.runTests()
    }
    
    private func runTests() {
        let testInput = ["London to Dublin = 464",
                         "London to Belfast = 518",
                         "Dublin to Belfast = 141"]
        
        self.generatePaths(from: testInput)
    }
    
    private func generatePaths(from strings: [String]) {
        for string in strings {
            let split = string.split(separator: " ")
            let locA = String(split[0])
            let locB = String(split[2])
            let distance = Int(split[4])!
            self.locations.insert(locA)
            self.locations.insert(locB)
            
            let sorted = [locA, locB].sorted()
            let key = "\(sorted[0])-\(sorted[1])"
            self.distances[key] = distance
        }
    }
    
    private func findShortestDistance() -> Int {
        var shortest = Int.max
        for permutation in PermutationHelper.allPermutations(Array(self.locations)) {
            var currDistance = 0
            for i in 0..<permutation.count - 1 {
                let locA = permutation[i]
                let locB = permutation[i + 1]
                let sorted = [locA, locB].sorted()
                let key = "\(sorted[0])-\(sorted[1])"
                let distance = self.distances[key]!
                currDistance += distance
                
                if currDistance > shortest {
                    break
                }
            }
            shortest = min(shortest, currDistance)
        }
    
        return shortest
    }
    
    private func findLongestDistance() -> Int {
        var longest = 0
        for permutation in PermutationHelper.allPermutations(Array(self.locations)) {
            var currDistance = 0
            for i in 0..<permutation.count - 1 {
                let locA = permutation[i]
                let locB = permutation[i + 1]
                let sorted = [locA, locB].sorted()
                let key = "\(sorted[0])-\(sorted[1])"
                let distance = self.distances[key]!
                currDistance += distance
            }
            longest = max(longest, currDistance)
        }
    
        return longest
    }
    
    func solveFirst() {
        let shortestPathDistance = self.findShortestDistance()
        self.setSolution(challenge: 0, text: "\(shortestPathDistance)")
    }
    
    func solveSecond() {
        let longestPathDistance = self.findLongestDistance()
        self.setSolution(challenge: 1, text: "\(longestPathDistance)")
    }
}
