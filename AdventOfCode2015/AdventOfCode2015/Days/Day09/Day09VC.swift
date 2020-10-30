//
//  Day09VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 28/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day09VC: AoCVC, AdventDay, InputLoadable {
    
    private var input: [String] = []
    private var locations: Set<String> = []
    private var distances: [String : Int] = [:] // Loc1-Loc2 --> Distance
    
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
    }
    
    private func generatePaths(from strings: [String]) {
        for string in strings {
            let split = string.split(separator: " ")
            let locA = String(split[0])
            let locB = String(split[2])
            let distance = Int(split[4])!
            self.locations.insert(locA)
            self.locations.insert(locB)
            self.distances["\(locA)-\(locB)"] = distance
            self.distances["\(locB)-\(locA)"] = distance
        }
    }
    
    func solveFirst() {
        self.generatePaths(from: self.input)
        let permutations = PermutationHelper.allPermutations(Array(self.locations))
        let result = TravellingSalesmanHelper.findShortestDistance(locationPermutations: permutations, distanceMap: self.distances)
        let shortestDistance = result.shortestDistance!
        self.setSolution(challenge: 0, text: "\(shortestDistance)")
    }
    
    func solveSecond() {
        self.generatePaths(from: self.input)
        let permutations = PermutationHelper.allPermutations(Array(self.locations))
        let result = TravellingSalesmanHelper.findLongestDistance(locationPermutations: permutations, distanceMap: self.distances)
        let longestDistance = result.longestDistance!
        self.setSolution(challenge: 1, text: "\(longestDistance)")
    }
}

extension Day09VC: TestableDay {
    func runTests() {
        let testInput = ["London to Dublin = 464",
                         "London to Belfast = 518",
                         "Dublin to Belfast = 141"]
        
        self.generatePaths(from: testInput)
        let permutations = PermutationHelper.allPermutations(Array(self.locations))
        let result = TravellingSalesmanHelper.findDistances(locationPermutations: permutations, distanceMap: self.distances)
        assert(result.shortestDistance == 605)
        assert(result.longestDistance == 982)
        
        self.locations = []
        self.distances = [:]
    }
}
