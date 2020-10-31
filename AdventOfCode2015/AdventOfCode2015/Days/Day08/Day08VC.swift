//
//  Day08VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 28/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day08VC: AoCVC, AdventDay, InputLoadable {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    private func countAmountOfCharactersInCode(for string: String) -> Int {
        return string.trimmingCharacters(in: .whitespacesAndNewlines).count
    }
    
    private func countCharactersInString(for string: String) -> Int {
        var trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let doubleQuotePadding = 2
        var numChars = trimmed.count - doubleQuotePadding
        
        while let range = trimmed.range(of: #"\\"#) {
            trimmed = trimmed.replacingCharacters(in: range, with: "")
            numChars -= 1
        }
        
        while let range = trimmed.range(of: #"\""#) {
            trimmed = trimmed.replacingCharacters(in: range, with: "")
            numChars -= 1
        }
        
        while let range = trimmed.range(of: #"\x"#) {
            trimmed = trimmed.replacingCharacters(in: range, with: "")
            numChars -= 3
        }
        
        return numChars
    }
    
    private func countReencodedCharacters(for string: String) -> Int {
        let doubleQuotePadding = 2
        var numChars = string.count + doubleQuotePadding
        
        for char in string {
            if char == #"\"# {
                numChars += 1
            } else if char == "\"" {
                numChars += 1
            }
        }
        
        return numChars
    }
    
    func solveFirst() {
        let charsInCode = self.input.map({self.countAmountOfCharactersInCode(for: $0)}).reduce(0, +)
        let charsInString = self.input.map({self.countCharactersInString(for: $0)}).reduce(0, +)
        let result = charsInCode - charsInString
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let charsInCode = self.input.map({self.countAmountOfCharactersInCode(for: $0)}).reduce(0, +)
        let reencodedCharacterCount = self.input.map({self.countReencodedCharacters(for: $0)}).reduce(0, +)
        let result = reencodedCharacterCount - charsInCode
        self.setSolution(challenge: 1, text: "\(result)")
    }
}

extension Day08VC: TestableDay {
    func runTests() {
        let tests = [
            self.input[1],
            self.input[10],
            self.input[281],
            self.input[19],
            self.input[64],
            self.input[59],
            self.input[150],
            self.input[20],
            self.input[70]
        ]
        let charsInCode = tests.map({self.countAmountOfCharactersInCode(for: $0)})
        assert(charsInCode == [6, 11, 3, 11, 27, 7, 35, 21, 36])
        
        let charsInString = tests.map({self.countCharactersInString(for: $0)})
        assert(charsInString == [4, 8, 1, 8, 23, 2, 31, 17, 26])
    }
}
