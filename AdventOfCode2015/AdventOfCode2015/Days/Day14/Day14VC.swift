//
//  Day14VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 29/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day14VC: AoCVC, AdventDay, InputLoadable {
    class Reindeer {
        let name: String
        let speed: Int
        let stamina: Int
        let recovery: Int
        var score: Int
        
        init(name: String, speed: Int, stamina: Int, recovery: Int) {
            self.name = name
            self.speed = speed
            self.stamina = stamina
            self.recovery = recovery
            self.score = 0
        }
        
        func totalDistance(after endTime: Int) -> Int {
            let cycleLength = self.stamina + self.recovery
            let numFullCycles = endTime / cycleLength
            
            let remainingTime = endTime % cycleLength
            let remainingFlightTime = min(remainingTime, self.stamina)
            
            let totalFlightTime = numFullCycles * self.stamina + remainingFlightTime
            return totalFlightTime * self.speed
        }
        
        static func from(string: String) -> Reindeer {
            let split = string.split(separator: " ")
            return Reindeer(name: String(split[0]),
                            speed: Int(split[3])!,
                            stamina: Int(split[6])!,
                            recovery: Int(split[13])!)
        }
    }
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    private func raceWithScoring(reindeer: [Reindeer], seconds: Int) {
        for i in 1...seconds {
            let bestDistance = reindeer.max(by: {$0.totalDistance(after: i) < $1.totalDistance(after: i)})!
                .totalDistance(after: i)
            reindeer.forEach { (reindeer) in
                if reindeer.totalDistance(after: i) == bestDistance {
                    reindeer.score += 1
                }
            }
        }
    }
    
    func solveFirst() {
        let raceTime = 2503
        let reindeer = self.input.map({Reindeer.from(string: $0)})
        let winningDistance = reindeer.map({$0.totalDistance(after: raceTime)}).max(by: <)!
        
        self.setSolution(challenge: 0, text: "\(winningDistance)")
    }
    
    func solveSecond() {
        let raceTime = 2503
        let reindeer = self.input.map({Reindeer.from(string: $0)})
        
        self.raceWithScoring(reindeer: reindeer, seconds: raceTime)
        let winningScore = reindeer.map({$0.score}).max(by: <)!
        
        self.setSolution(challenge: 1, text: "\(winningScore)")
    }
}

extension Day14VC: TestableDay {
        func runTests() {
            let testInput = """
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    """
                .split(separator: "\n").map({String($0)})
            let reindeer = testInput.map({Reindeer.from(string: $0)})
            let times = [1, 10, 11, 1000]
            let distances = times.map { (time) -> [Int] in
                return reindeer.map({$0.totalDistance(after: time)})
            }
            let expectedDistances = [[14, 16], [140, 160], [140, 176], [1120, 1056]]
            assert(distances == expectedDistances)
            
            self.raceWithScoring(reindeer: reindeer, seconds: 1000)
            
            assert(reindeer[0].score == 312)
            assert(reindeer[1].score == 689)
        }
}
