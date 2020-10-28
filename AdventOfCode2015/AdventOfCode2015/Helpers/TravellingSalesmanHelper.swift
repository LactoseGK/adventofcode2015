//
//  TravellingSalesmanHelper.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 28/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import Foundation

class TravellingSalesmanHelper {
    static func findShortestDistance(locationPermutations: [[String]], distanceMap: [String : Int]) -> Int {
        var shortest = Int.max
        for permutation in locationPermutations {
            var currDistance = 0
            for i in 0..<permutation.count - 1 {
                let key = "\(permutation[i])-\(permutation[i + 1])"
                let distance = distanceMap[key]!
                currDistance += distance
                
                if currDistance > shortest {
                    break
                }
            }
            shortest = min(shortest, currDistance)
        }
    
        return shortest
    }
    
    static func findLongestDistance(locationPermutations: [[String]], distanceMap: [String : Int]) -> Int {
        var longest = 0
        for permutation in locationPermutations {
            var currDistance = 0
            for i in 0..<permutation.count - 1 {
                let key = "\(permutation[i])-\(permutation[i + 1])"
                let distance = distanceMap[key]!
                currDistance += distance
            }
            longest = max(longest, currDistance)
        }
    
        return longest
    }
    
    static func findDistances(locationPermutations: [[String]], distanceMap: [String : Int]) -> (shortest: Int, longest: Int) {
        var shortest = Int.max
        var longest = 0
        for permutation in locationPermutations {
            var currDistance = 0
            for i in 0..<permutation.count - 1 {
                let key = "\(permutation[i])-\(permutation[i + 1])"
                let distance = distanceMap[key]!
                currDistance += distance
            }
            shortest = min(shortest, currDistance)
            longest = max(longest, currDistance)
        }
        
        return (shortest: shortest, longest: longest)
    }
}
