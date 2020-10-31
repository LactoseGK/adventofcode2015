//
//  Day19VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 30/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day19VC: AoCVC, AdventDay, InputLoadable {
    private var input: String!
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextString()
    }
    
    struct Replacement {
        let from: String
        let to: String
        
        static func from(_ string: String) -> Replacement {
            let parts = string.components(separatedBy: " => ")
            return Replacement(from: parts[0], to: parts[1])
        }
    }
    
    func solveFirst() {
        let parsed = self.getReplacementsAndChemical(from: self.input)
        let distinct = self.findDistinctMoleculesAfterReplacements(in: parsed.chemical, with: parsed.replacements)
        self.setSolution(challenge: 0, text: "\(distinct.count)")
    }
    
    func solveSecond() {
        let parsed = self.getReplacementsAndChemical(from: self.input)
        let minSteps = self.getNumStepsToMake(chemical: parsed.chemical, using: parsed.replacements)
        self.setSolution(challenge: 1, text: "\(minSteps!)")
    }
    
    // Fairly hacky. Assumes longest replacement = best/always valid.
    private func getReplacementsAndChemical(from string: String) -> (replacements: [Replacement], chemical: String) {
        let split = string.components(separatedBy: "\n\n")
        
        let replacements = split[0].components(separatedBy: "\n").map({Replacement.from($0)}).sorted(by: {$0.to.count > $1.to.count})
        let chemical = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (replacements: replacements, chemical: chemical)
    }
    
    private func findDistinctMoleculesAfterReplacements(in chemical: String, with replacements: [Replacement]) -> Set<String> {
        var resultantChemicals: Set<String> = []
        replacements.forEach { (replacement) in
            chemical.ranges(of: replacement.from).forEach { (replacementRange) in
                let result = chemical.replacingCharacters(in: replacementRange, with: replacement.to)
                resultantChemicals.insert(result)
            }
        }
        return resultantChemicals
    }
    
    // Fairly hacky. Assumes first replacement found is always valid.
    private func getNumStepsToMake(chemical: String, using replacements: [Replacement]) -> Int? {
        if chemical == "e" {
            return 0
        }
        
        for replacement in replacements {
            for replacementRange in chemical.ranges(of: replacement.to) {
                let prevChemicalStep = chemical.replacingCharacters(in: replacementRange, with: replacement.from)
                if let recursiveResult = self.getNumStepsToMake(chemical: prevChemicalStep, using: replacements) {
                    return 1 + recursiveResult
                }
            }
        }
        return nil
    }
}

extension Day19VC: TestableDay {
    func runTests() {
        self.runTests1()
        self.runTests2()
    }
    
    private func runTests1() {
                let testInput = """
        H => HO
        H => OH
        O => HH

        HOH
        """
                let parsed = self.getReplacementsAndChemical(from: testInput)
                assert(parsed.replacements.count == 3)
                assert(parsed.replacements[0].from == "H")
                assert(parsed.replacements[0].to == "HO")
                assert(parsed.replacements[1].from == "H")
                assert(parsed.replacements[1].to == "OH")
                assert(parsed.replacements[2].from == "O")
                assert(parsed.replacements[2].to == "HH")
                assert(parsed.chemical == "HOH")
                
                let expectedDistinct: Set<String> = Set(["HOOH", "HOHO", "OHOH", "HOOH", "HHHH"])
                let distinct = self.findDistinctMoleculesAfterReplacements(in: parsed.chemical, with: parsed.replacements)
                assert(distinct == expectedDistinct)
    }
    
    private func runTests2() {
        let testInput = """
        e => H
        e => O
        H => HO
        H => OH
        O => HH

        HOH
        """
        let parsed = self.getReplacementsAndChemical(from: testInput)
        assert(self.getNumStepsToMake(chemical: "HOH", using: parsed.replacements) == 3)
        assert(self.getNumStepsToMake(chemical: "HOHOHO", using: parsed.replacements) == 6)
    }
}
