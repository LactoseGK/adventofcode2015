
//
//  Day02VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 27/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day02VC: AoCVC, AdventDay, InputLoadable {
    struct Box {
        let width: Int
        let height: Int
        let length: Int
        
        var surfaceAreaWithPadding: Int {
            let sides = [2 * self.length * self.width,
                         2 * self.width * self.height,
                         2 * self.height * self.length]
            let shortest = sides.sorted().first! / 2
            return sides.reduce(0, +) + shortest
        }
        
        private var volume: Int {
            return self.length * self.width * self.height
        }
        
        var ribbonRequirements: Int {
            let perimeters = [2 * (self.length + self.width),
                              2 * (self.width + self.height),
                              2 * (self.height + self.length)
            ]
            let shortest = perimeters.sorted().first!
            return shortest + self.volume
        }
        
        static func fromString(string: String) -> Box {
            let parts = string.split(separator: "x").map({Int($0)!})
            return Box(width: parts[0], height: parts[1], length: parts[2])
            
        }
    }
    
    private var input: [String] = []
    private var boxes: [Box] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
        self.boxes = self.input.map(Box.fromString)
    }
    
    func solveFirst() {
        let totalArea = self.boxes.map({$0.surfaceAreaWithPadding}).reduce(0, +)
        self.setSolution(challenge: 0, text: "\(totalArea)")
    }
    
    func solveSecond() {
        let totalRibbonLength = self.boxes.map({$0.ribbonRequirements}).reduce(0, +)
        self.setSolution(challenge: 1, text: "\(totalRibbonLength)")
    }
}

extension Day02VC: TestableDay {
    func runTests() {
        assert(Box(width: 2, height: 3, length: 4).surfaceAreaWithPadding == 58)
        assert(Box(width: 1, height: 1, length: 10).surfaceAreaWithPadding == 43)
        
        assert(Box(width: 2, height: 3, length: 4).ribbonRequirements == 34)
        assert(Box(width: 1, height: 1, length: 10).ribbonRequirements == 14)
    }
}
