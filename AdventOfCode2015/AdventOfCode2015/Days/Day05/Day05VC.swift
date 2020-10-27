//
//  Day05VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 27/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day05VC: AoCVC, AdventDay {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
//        self.runTests()
    }
    
    enum WordType {
        case naughty
        case nice
    }
    
    private func runTests() {
        assert(self.checkWord("ugknbfddgicrmopn") == .nice)
        assert(self.checkWord("aaa") == .nice)
        assert(self.checkWord("jchzalrnumimnmhp") == .naughty)
        assert(self.checkWord("haegwjzuvuyypxyu") == .naughty)
        assert(self.checkWord("dvszwmarrgswjxmb") == .naughty)
        
        
        assert(self.checkWord2("qjhvhtzxzqqjkmpb") == .nice)
        assert(self.checkWord2("xxyxx") == .nice)
        assert(self.checkWord2("uurcxstgmygtbstg") == .naughty)
        assert(self.checkWord2("ieodomkazucvgmuy") == .naughty)
        
        print("All tests OK.")
    }
    

    
    private func checkWord(_ string: String) -> WordType {
        let disallowedStrings = ["ab",
                                 "cd",
                                 "pq",
                                 "xy"]
        for disallowedString in disallowedStrings {
            if string.contains(disallowedString) {
                return .naughty
            }
        }
        
        let vowels = string.filter({ (char) -> Bool in
            let s = String(char)
            return s == "a" || s == "e" || s == "i" || s == "o" || s == "u"
        })
        
        if vowels.count < 3 {
            return .naughty
        }
        
        let arrayed = string.toStringArray()
        for i in 1..<arrayed.count {
            if arrayed[i - 1] == arrayed[i] {
                return .nice
            }
        }
        
        return .naughty
    }
    
    func solveFirst() {
        var numNice = 0
        var numNaughty = 0
        self.input.forEach { (string) in
            if self.checkWord(string) == .naughty {
                numNaughty += 1
            } else {
                numNice += 1
            }
        }
        self.setSolution(challenge: 0, text: "\(numNice)")
    }
    
    func solveSecond() {
        var numNice = 0
        var numNaughty = 0
        self.input.forEach { (string) in
            if self.checkWord2(string) == .naughty {
                numNaughty += 1
            } else {
                numNice += 1
            }
        }
        self.setSolution(challenge: 1, text: "\(numNice)")
    }
    
    private func checkWord2(_ string: String) -> WordType {
        let arrayed = string.toStringArray()
        
        var duplicatePair = false
        for i in 1..<arrayed.count {
            let search = "\(arrayed[i-1])\(arrayed[i])"
            let replaced = string.replacingOccurrences(of: search, with: "")
            if replaced.count + 4 <= string.count {
                duplicatePair = true
                break
            }
        }
        if !duplicatePair {
            return .naughty
        }
        
        var repeatedWithGap = false
        for i in 2..<arrayed.count {
            if arrayed[i - 2] == arrayed[i] && arrayed[i - 2] != arrayed[i - 1] {
                repeatedWithGap = true
                break
            }
        }
        return repeatedWithGap ? .nice : .naughty
    }
}
