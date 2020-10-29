//
//  Day10VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 29/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day10VC: AoCVC, AdventDay {
    
    func loadInput() {
    }
    
    func runTests() {
        let tests = ["211",
                     "111"]
        let results = tests.map({self.lookAndSay($0)})
        assert(results == ["1221", "31"])
    }
    
    private func lookAndSay(_ string: String) -> String {
        var newString = ""
        
        var prevChar = string.first!
        var numCount = 0
        
        string.forEach { (char) in
            if char == prevChar {
                numCount += 1
            } else {
                newString.append("\(numCount)\(prevChar)")
                numCount = 1
            }
            prevChar = char
        }

        newString.append("\(numCount)\(prevChar)")
        
        return newString
    }
    
    func solveFirst() {
        let initial = "1113222113"
        var result = initial
        for _ in 0..<40 {
            result = self.lookAndSay(result)
        }
        
        self.setSolution(challenge: 0, text: "\(result.count)")
    }
    
    func solveSecond() {
        let initial = "1113222113"
        var result = initial
        for _ in 0..<50 {
            result = self.lookAndSay(result)
        }
        
        self.setSolution(challenge: 1, text: "\(result.count)")
    }
}
