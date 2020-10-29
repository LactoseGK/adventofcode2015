//
//  Day01VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 27/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day01VC: AoCVC, AdventDay {
    private var input: String!
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextFirstLine()
    }
    
    func runTests() {
        assert(self.calculateFloor(for: "(())") == 0)
        assert(self.calculateFloor(for: "()()") == 0)
        assert(self.calculateFloor(for: "(((") == 3)
        assert(self.calculateFloor(for: "(()(()(") == 3)
        assert(self.calculateFloor(for: "))(((((") == 3)
        assert(self.calculateFloor(for: "())") == -1)
        assert(self.calculateFloor(for: "))(") == -1)
        assert(self.calculateFloor(for: ")))") == -3)
        assert(self.calculateFloor(for: ")())())") == -3)
    }
    
    func solveFirst() {
        let solution = self.calculateFloor(for: self.input)
        self.setSolution(challenge: 0, text: "\(solution)")
    }
    
    private func calculateFloor(for string: String) -> Int {
        return string.map(self.getFloorAdjustment).reduce(0, +)

    }
    
    func solveSecond() {
        var floor = 0
        for (index, c) in self.input.enumerated() {
            floor += self.getFloorAdjustment(for: c)
            if floor == -1 {
                self.setSolution(challenge: 1, text: "\(index + 1)")
                break
            }
        }
    }
    
    private func getFloorAdjustment(for char: Character) -> Int {
        switch char {
        case "(":
            return 1
        case ")":
            return -1
        default: return 0
        }
    }
}
