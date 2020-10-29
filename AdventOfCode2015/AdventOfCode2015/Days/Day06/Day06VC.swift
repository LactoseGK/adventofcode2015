//
//  Day06VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 27/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day06VC: AoCVC, AdventDay {
    enum Command {
        case turn_on(minExtents: IntPoint, maxExtents: IntPoint)
        case toggle(minExtents: IntPoint, maxExtents: IntPoint)
        case turn_off(minExtents: IntPoint, maxExtents: IntPoint)
    }
    
    private var lightGrid: [IntPoint: Bool] = [:] // Pos --> Enabled
    private var lightGrid2: [IntPoint: Int] = [:] // Pos --> Intensity
    
    func loadInput() {
        let gridInfo = GridInfo(minExtents: .origin, maxExtents: IntPoint(x: 999, y: 999))
        gridInfo.allPoints.forEach { (point) in
            lightGrid[point] = false
            lightGrid2[point] = 0
        }
        self.input = self.defaultInputFileString.loadAsTextLines()
    }
    
    func runTests() {
        let tests = [
            "turn on 0,0 through 999,999",
            "toggle 0,0 through 999,0",
            "turn off 499,499 through 500,500"
        ]
        
        tests.forEach { (test) in
            let command = getCommand(for: test)
            switch command {
            case .turn_on(let minExtents, let maxExtents):
                assert(GridInfo(minExtents: minExtents, maxExtents: maxExtents).allPoints.count == 1000 * 1000)
            case .toggle(let minExtents, let maxExtents):
                assert(GridInfo(minExtents: minExtents, maxExtents: maxExtents).allPoints.count == 1000)
            case .turn_off(let minExtents, let maxExtents):
                let gridInfo = GridInfo(minExtents: minExtents, maxExtents: maxExtents)
                assert(gridInfo.allPoints.count == 4)
            }
        }
        
        print("All tests OK.")
    }
    
    private var input: [String] = []
    
    func solveFirst() {
        self.input.forEach { (string) in
            let command = self.getCommand(for: string)
            self.execute(command: command, ancientElvish: false)
        }
        
        let enabled = self.lightGrid.filter { (pos, flag) -> Bool in
            return flag
        }
        let enabledCount = enabled.count
        self.setSolution(challenge: 0, text: "\(enabledCount)")
    }
    
    private func getCommand(for string: String) -> Command {
        let split = string.split(separator: " ")
        if string.hasPrefix("turn on") {
            let minExtents = self.getIntPoint(from: String(split[2]))
            let maxExtents = self.getIntPoint(from: String(split[4]))
            return .turn_on(minExtents: minExtents, maxExtents: maxExtents)
        } else if string.hasPrefix("toggle") {
            let minExtents = self.getIntPoint(from: String(split[1]))
            let maxExtents = self.getIntPoint(from: String(split[3]))
            return .toggle(minExtents: minExtents, maxExtents: maxExtents)
        } else if string.hasPrefix("turn off") {
            let minExtents = self.getIntPoint(from: String(split[2]))
            let maxExtents = self.getIntPoint(from: String(split[4]))
            return .turn_off(minExtents: minExtents, maxExtents: maxExtents)
        }
        
        fatalError("Invalid string.")
    }
    
    private func getIntPoint(from string: String) -> IntPoint {
        let split = string.split(separator: ",")
        let x = Int(split[0])!
        let y = Int(split[1])!
        return IntPoint(x: x, y: y)
    }
    
    private func execute(command: Command, ancientElvish: Bool) {
        switch command {
        case .turn_on(let minExtents, let maxExtents):
            GridInfo(minExtents: minExtents, maxExtents: maxExtents)
                .allPoints
                .forEach { (point) in
                    if ancientElvish {
                        self.lightGrid2[point] = self.lightGrid2[point]! + 1
                    } else {
                        self.lightGrid[point] = true
                    }
            }
        case .toggle(let minExtents, let maxExtents):
            GridInfo(minExtents: minExtents, maxExtents: maxExtents)
                .allPoints
                .forEach { (point) in
                    if ancientElvish {
                        self.lightGrid2[point] = self.lightGrid2[point]! + 2
                    } else {
                        self.lightGrid[point]!.toggle()
                    }
            }
        case .turn_off(let minExtents, let maxExtents):
            GridInfo(minExtents: minExtents, maxExtents: maxExtents)
                .allPoints
                .forEach { (point) in
                    if ancientElvish {
                        self.lightGrid2[point] = max(0, self.lightGrid2[point]! - 1)
                    } else {
                        self.lightGrid[point] = false
                    }
            }
        }
    }
    
    func solveSecond() {
        self.input.forEach { (string) in
            let command = self.getCommand(for: string)
            self.execute(command: command, ancientElvish: true)
        }
        
        let totalIntensity = self.lightGrid2.values.reduce(0, +)
        self.setSolution(challenge: 1, text: "\(totalIntensity)")
    }
}
