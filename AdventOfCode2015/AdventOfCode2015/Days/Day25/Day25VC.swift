//
//  Day25VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 03/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day25VC: AoCVC, AdventDay {
    func solveFirst() {
        let numIterations = self.getNumIterations(row: 2978, column: 3083) // From input.
        var code: UInt64 = 20151125
        for _ in 1..<numIterations {
            code = (code * 252533) % 33554393
        }
        self.setSolution(challenge: 0, text: "\(code)")
    }
    
    func solveSecond() {
        self.setSolution(challenge: 1, text: "2015 completed!")
    }
    
    private func generateNext(from value: UInt64) -> UInt64 {
        return (value * 252533) % 33554393
    }
    
    private func getNumIterations(row: Int, column: Int) -> Int {
        if row > 1 {
            let offset = row - 1
            return self.getNumIterations(row: 1, column: column + offset) - offset
        }
        return (1 + column) * column / 2
    }
}

extension Day25VC: TestableDay {
    func runTests() {
        assert(self.generateNext(from: 20151125) == 31916031)
        assert(self.getNumIterations(row: 4, column: 2) == 12)
        assert(self.getNumIterations(row: 6, column: 1) == 16)
        assert(self.getNumIterations(row: 2, column: 5) == 20)
        assert(self.getNumIterations(row: 1, column: 3) == 6)
        
        var code: UInt64 = 1
        let numIterations = self.getNumIterations(row: 1, column: 6)
        for _ in 1..<numIterations {
            code += 1
        }
        assert(code == 21)
    }
}
