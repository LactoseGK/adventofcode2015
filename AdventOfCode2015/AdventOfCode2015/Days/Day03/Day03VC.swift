//
//  Day03VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 27/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day03VC: AoCVC, AdventDay {
    private var giftDictionary: [IntPoint : Int] = [:] // Position --> gifts given
    
    private var input: String!
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextFirstLine()
    }
    
    func runTests() {
        self.deliverToHouses(directionString: ">")
        assert(self.giftDictionary.count == 2)
        
        self.deliverToHouses(directionString: "^>v<")
        assert(self.giftDictionary.count == 4)
        
        self.deliverToHouses(directionString: "^v^v^v^v^v")
        assert(self.giftDictionary.count == 2)
        
        
        self.deliverToHouses(directionString: "^v", roboSantaActive: true)
        assert(self.giftDictionary.count == 3)
        
        self.deliverToHouses(directionString: "^>v<", roboSantaActive: true)
        assert(self.giftDictionary.count == 3)
        
        self.deliverToHouses(directionString: "^v^v^v^v^v", roboSantaActive: true)
        assert(self.giftDictionary.count == 11)
    }
    
    
    private func deliverToHouses(directionString: String, roboSantaActive: Bool = false) {
        self.giftDictionary = [:]
        var santaPosition = IntPoint.origin
        var roboSantaPosition = IntPoint.origin
        self.deliverToHouse(at: santaPosition)
        self.deliverToHouse(at: roboSantaPosition)
        for (index, char) in directionString.enumerated() {
            let direction = Direction.from(string: String(char))
            let moveRoboSanta = roboSantaActive && (index % 2 == 1)
            if moveRoboSanta {
                roboSantaPosition = roboSantaPosition.move(in: direction, numSteps: 1)
                self.deliverToHouse(at: roboSantaPosition)
            } else {
                santaPosition = santaPosition.move(in: direction, numSteps: 1)
                self.deliverToHouse(at: santaPosition)
            }
        }
    }
    
    private func deliverToHouse(at position: IntPoint) {
        self.giftDictionary[position] = (self.giftDictionary[position] ?? 0) + 1
    }
    
    func solveFirst() {
        self.deliverToHouses(directionString: self.input)
        self.setSolution(challenge: 0, text: "\(self.giftDictionary.count)")
    }
    
    func solveSecond() {
        self.deliverToHouses(directionString: self.input, roboSantaActive: true)
        self.setSolution(challenge: 1, text: "\(self.giftDictionary.count)")
    }
}
