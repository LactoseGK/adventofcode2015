//
//  Day07VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 28/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day07VC: AoCVC, AdventDay, InputLoadable {
    enum Operator {
        case AND(wireA: String, wireB: String)
        case OR(wireA: String, wireB: String)
        case LSHIFT(wire: String, numShifts: Int)
        case RSHIFT(wire: String, numShifts: Int)
        case NOT(wire: String)
        case COPY(wire: String)
    }
    
    struct Instruction {
        let _operator: Operator
        let destination: String
    }
    
    private var wires: [String: UInt16] = [:] //ID --> Wire signal
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
    }
    
    private func parse(_ string: String) -> Instruction {
        let split = string.split(separator: " ")
        let destination = String(split.last!)
        if split[1] == "->" {
            return Instruction(_operator: .COPY(wire: String(split[0])), destination: destination)
        }
        
        if split[0] == "NOT" {
            let id = String(split[1])
            return Instruction(_operator: .NOT(wire: id), destination: destination)
        }
        
        let idA = String(split[0])
        if split[1] == "LSHIFT" {
            let numShifts = Int(split[2])!
            return Instruction(_operator: .LSHIFT(wire: idA, numShifts: numShifts), destination: destination)
        } else if split[1] == "RSHIFT" {
            let numShifts = Int(split[2])!
            return Instruction(_operator: .RSHIFT(wire: idA, numShifts: numShifts), destination: destination)
        }

        let idB = String(split[2])
        if split[1] == "AND" {
            return Instruction(_operator: .AND(wireA: idA, wireB: idB), destination: destination)
        } else if split[1] == "OR" {
            return Instruction(_operator: .OR(wireA: idA, wireB: idB), destination: destination)
        }
        
        fatalError("Unable to parse string")
    }
    
    private func evaluate(wire: String, in instructions: [Instruction]) -> UInt16 {
        if let intValue = UInt16(wire) {
            return intValue
        }
        
        if let signal = self.wires[wire] {
            return signal
        }
        
        guard let instruction = instructions.first(where: {$0.destination == wire}) else {
            fatalError("No valid instruction found")
        }
        
        let value = self.getValue(for: instruction, in: instructions)
        self.wires[wire] = value
        
        return value
    }
    
    
    private func getValue(for instruction: Instruction, in instructions: [Instruction]) -> UInt16 {
        switch instruction._operator {
        case .AND(let wireA, let wireB):
            let a = self.evaluate(wire: wireA, in: instructions)
            let b = self.evaluate(wire: wireB, in: instructions)
            return a & b
        case .OR(let wireA, let wireB):
            let a = self.evaluate(wire: wireA, in: instructions)
            let b = self.evaluate(wire: wireB, in: instructions)
            return a | b
        case .LSHIFT(let wire, let numShifts):
            let value = self.evaluate(wire: wire, in: instructions)
            return value << numShifts
        case .RSHIFT(let wire, let numShifts):
            let value = self.evaluate(wire: wire, in: instructions)
            return value >> numShifts
        case .NOT(let wire):
            let value = self.evaluate(wire: wire, in: instructions)
            return ~value
        case .COPY(let wire):
            let value = self.evaluate(wire: wire, in: instructions)
            return value
        }
    }
    
    func solveFirst() {
        let instructions = self.input.map({self.parse($0)})
        let value = self.evaluate(wire: "a", in: instructions)
        self.wires.removeAll()
        self.setSolution(challenge: 0, text: "\(value)")
    }
    
    func solveSecond() {
        let instructions = self.input.map({self.parse($0)})
        let valueFirstRun = self.evaluate(wire: "a", in: instructions)
        self.wires.removeAll()
        var instructionsPart2 = instructions.filter({$0.destination != "b"})
        instructionsPart2.append(Instruction(_operator: .COPY(wire: "\(valueFirstRun)"), destination: "b"))
        let value = self.evaluate(wire: "a", in: instructionsPart2)
        self.setSolution(challenge: 1, text: "\(value)")
    }
}


extension Day07VC: TestableDay {
    func runTests() {
        let tests = [
            "123 -> x",
            "456 -> y",
            "x AND y -> d",
            "x OR y -> e",
            "x LSHIFT 2 -> f",
            "y RSHIFT 2 -> g",
            "NOT x -> h",
            "NOT y -> i"
        ]
        
        let instructions = tests.map({self.parse($0)})
        let values = ["d", "e", "f", "g", "h", "i", "x", "y"].map({self.evaluate(wire: $0, in: instructions)})
        self.wires.removeAll()
        assert(values == [72, 507, 492, 114, 65412, 65079, 123, 456])
        
        
        let tests2 = [
            "43690 -> d",
            "21845 -> c",
            "c AND d -> b",
            "NOT b -> a"
        ]
        
        let instructions2 = tests2.map({self.parse($0)})
        let values2 = ["d", "c", "b", "a"].map({self.evaluate(wire: $0, in: instructions2)})
        self.wires.removeAll()
        assert(values2 == [43690, 21845, 0, 65535])
    }
}
