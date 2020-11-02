//
//  Day23VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 02/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day23VC: AoCVC, AdventDay, InputLoadable {
    enum Instruction {
        case hlf(register: String)
        case tpl(register: String)
        case inc(register: String)
        case jmp(offset: Int)
        case jie(register: String, offset: Int)
        case jio(register: String, offset: Int)
        
        static func from(string: String) -> Instruction {
            let trimmed = string.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            let components = trimmed.components(separatedBy: " ")
            switch components[0] {
            case "hlf":
                return .hlf(register: components[1])
            case "tpl":
                return .tpl(register: components[1])
            case "inc":
                return .inc(register: components[1])
            case "jmp":
                return .jmp(offset: components[1].intValue!)
            case "jie":
                return .jie(register: components[1], offset: components[2].intValue!)
            case "jio":
                return .jio(register: components[1], offset: components[2].intValue!)
            default:
                fatalError("Invalid string")
            }
        }
    }
    
    class Computer {
        var registers: [String : Int] = [:] // Name --> Value
        var instructionIndex: Int = 0
        
        init(registerNames: [String]) {
            registerNames.forEach({self.registers[$0] = 0})
        }
        
        func run(instructions: [Instruction]) {
            while self.instructionIndex >= 0 && self.instructionIndex < instructions.count {
                apply(instruction: instructions[self.instructionIndex])
            }
        }
        
        func apply(instruction: Instruction) {
            self.perform(instruction: instruction)
            self.updateInstructionPointer(from: instruction)
        }
        
        private func perform(instruction: Instruction) {
            switch instruction {
            case .hlf(let register):
                self.registers[register]! /= 2
            case .tpl(let register):
                self.registers[register]! *= 3
            case .inc(let register):
                self.registers[register]! += 1
            case .jmp:
                break
            case .jie:
                break
            case .jio:
                break
            }
        }
        
        private func updateInstructionPointer(from instruction: Instruction) {
            switch instruction {
            case .hlf:
                self.instructionIndex += 1
            case .tpl:
                self.instructionIndex += 1
            case .inc:
                self.instructionIndex += 1
            case .jmp(let offset):
                self.instructionIndex += offset
            case .jie(let register, let offset):
                if self.registers[register]! % 2 == 0 {
                    self.instructionIndex += offset
                } else {
                    self.instructionIndex += 1
                }
            case .jio(let register, let offset):
                if self.registers[register]! == 1 {
                    self.instructionIndex += offset
                } else {
                    self.instructionIndex += 1
                }
            }
        }
    }
    
    private var input: [String] = []
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    func solveFirst() {
        let instructions = self.input.map({Instruction.from(string: $0)})
        let registers: [String] = ["a", "b", "c"]
        let computer = Computer(registerNames: registers)
        computer.run(instructions: instructions)
        
        self.setSolution(challenge: 0, text: "\(computer.registers["b"]!)")
    }
    
    func solveSecond() {
        let instructions = self.input.map({Instruction.from(string: $0)})
        let registers: [String] = ["a", "b", "c"]
        let computer = Computer(registerNames: registers)
        computer.registers["a"] = 1
        computer.run(instructions: instructions)
        
        self.setSolution(challenge: 1, text: "\(computer.registers["b"]!)")
    }
}


extension Day23VC: TestableDay {
    func runTests() {
        let input = """
inc a
jio a, +2
tpl a
inc a
"""
        let registers: [String] = ["a", "b", "c"]
        let instructions = input.components(separatedBy: "\n").map({Instruction.from(string: $0)})
        let computer = Computer(registerNames: registers)
        computer.run(instructions: instructions)
        assert(computer.registers["a"] == 2)
    }
}
