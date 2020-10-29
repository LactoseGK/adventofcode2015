//
//  Day11VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 29/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day11VC: AoCVC, AdventDay {
    private var charToInt: [String : Int] = [:]
    private var intToChar: [Int : String] = [:]
    
    func loadInput() {
        self.generateCharMap()
        self.runTests()
    }
    
    private func generateCharMap() {
        let chars = "abcdefghijklmnopqrstuvwxyz".toStringArray()
        for (index, char) in chars.enumerated() {
            self.charToInt[char] = index
            self.intToChar[index] = char
        }
    }
    
    private func runTests() {
        let testsA = ["xx", "xy", "xz", "ya"].map({self.nextPasswordAttempt(from: $0)})
        assert(testsA == ["xy", "xz", "ya", "yb"])
        
        assert(self.testAscendingCharacters(password: "hijklmmn") == true)
        assert(self.testIllegalCharacters(password: "hijklmmn") == false)
        
        assert(self.testLetterDoubles(password: "abbceffg") == true)
        assert(self.testAscendingCharacters(password: "abbceffg") == false)
        
        assert(self.testLetterDoubles(password: "abbcegjk") == false)
        
        assert(self.nextValidPassword(from: "abcdefgh") == "abcdffaa")
        assert(self.nextValidPassword(from: "ghijklmn") == "ghjaabcc")
        
        print("All tests OK.")
    }
    
    private func testAscendingCharacters(password: String) -> Bool {
        let arrayed = password.toStringArray().map({self.charToInt[$0]!})
        for i in 0..<arrayed.count - 2 {
            if (arrayed[i] == arrayed[i + 1] - 1) && (arrayed[i + 1] == arrayed[i + 2] - 1) {
                return true
            }
        }
        return false
    }
    
    private func testIllegalCharacters(password: String) -> Bool {
        let illegalCharacters = ["i", "o", "l"]
        for char in illegalCharacters {
            if password.contains(char) {
                return false
            }
        }
        
        return true
    }
    
    private func testLetterDoubles(password: String) -> Bool {
        var numDoubles = 0
        
        var currCount = 0
        var prevChar = password.first!
        password.forEach { (char) in
            if char == prevChar {
                currCount += 1
            } else {
                if currCount >= 2 {
                    numDoubles += 1
                }
                currCount = 1
            }
            prevChar = char
        }
        if currCount >= 2 {
            numDoubles += 1
        }
        
        return numDoubles >= 2
    }
    
    private func nextPasswordAttempt(from current: String) -> String {
        let shortcircuited = self.jumpToNextWithoutInvalidCharacters(from: current)
        var arrayed = shortcircuited.toStringArray()
        var currIndex = arrayed.count - 1
        var bumpNext = true
        while bumpNext {
            let currChar = arrayed[currIndex]
            let currValue = self.charToInt[currChar]!
            let nextValue = (currValue + 1) % self.charToInt.count
            let nextChar = self.intToChar[nextValue]!
            arrayed[currIndex] = nextChar
            currIndex -= 1
            bumpNext = (currIndex >= 0) && (nextValue == 0)
        }
        
        let next = arrayed.joined(separator: "")
        
        return next
    }
    
    private func jumpToNextWithoutInvalidCharacters(from current: String) -> String {
        if self.testIllegalCharacters(password: current) {
            return current
        }
        
        var arrayed = current.toStringArray()
        for (index, char) in arrayed.enumerated() {
            if !self.testIllegalCharacters(password: char) {
                let newValue = self.charToInt[char]! + 1
                let newChar = self.intToChar[newValue]!
                arrayed[index] = newChar
                for i in (index + 1)..<arrayed.count {
                    arrayed[i] = "a"
                }
                return arrayed.joined(separator: "")
            }
        }
        fatalError("Failed, but didn't correct?")
    }
    
    private func isValid(password: String) -> Bool {
        return self.testAscendingCharacters(password: password)
            && self.testIllegalCharacters(password: password)
            && self.testLetterDoubles(password: password)
    }
    
    private func nextValidPassword(from password: String) -> String {
        var currAttempt = password
        repeat {
            currAttempt = self.nextPasswordAttempt(from: currAttempt)
            if self.isValid(password: currAttempt) {
                return currAttempt
            }
        } while (true)
    }
    
    func solveFirst() {
        let initialPassword = "hepxcrrq"
        let nextPassword = self.nextValidPassword(from: initialPassword)
        self.setSolution(challenge: 0, text: nextPassword)
    }
    
    func solveSecond() {
        let initialPassword = "hepxcrrq"
        let nextPassword = self.nextValidPassword(from: initialPassword)
        let nextNext = self.nextValidPassword(from: nextPassword)
        self.setSolution(challenge: 1, text: nextNext)
    }
}
