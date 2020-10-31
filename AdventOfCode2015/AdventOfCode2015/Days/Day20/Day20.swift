//
//  Day20.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 31/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day20VC: AoCVC, AdventDay {
    func solveFirst() {
        let input = 29000000
        guard let houseNumber = self.getHouseNumber(presents: input, giftCount: 10) else { fatalError("Invalid input") }
        self.setSolution(challenge: 0, text: "\(houseNumber)")
    }
    
    func solveSecond() {
        let input = 29000000
        guard let houseNumber = self.getHouseNumber(presents: input, giftCount: 11, maxVisits: 50) else { fatalError("Invalid input") }
        self.setSolution(challenge: 1, text: "\(houseNumber)")
    }
    
    private func getHouseNumber(presents: Int, giftCount: Int, maxVisits: Int? = nil) -> Int? {
        let maxHouses = presents / giftCount
        var houses = Array(repeating: 0, count: maxHouses)
        for elfNumber in 1..<maxHouses {
            let maxHouse: Int
            if let maxVisits = maxVisits {
                maxHouse = (elfNumber * maxVisits).clamp(max: maxHouses)
            } else {
                maxHouse = maxHouses
            }
            for houseIndex in stride(from: (elfNumber - 1), to: maxHouse, by: elfNumber) {
                houses[houseIndex] += elfNumber * giftCount
            }
            if houses[elfNumber - 1] >= presents {
                return elfNumber
            }
        }
        return nil
    }
}

extension Day20VC: TestableDay {
    func runTests() {
        assert(self.getHouseNumber(presents: 40, giftCount: 10) == 3)
    }
}
