//
//  Day04VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 27/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit
import CryptoKit

class Day04VC: AoCVC, AdventDay {
    private var input = "yzbqklnj"
    
    func loadInput() {
    }
    
    func runTests() {
        assert(self.findFirstMD5(for: "abcdef", strict: false) == 609043)
        assert(self.findFirstMD5(for: "pqrstuv", strict: false) == 1048970)
    }
    
    private func findFirstMD5(for key: String, strict: Bool) -> Int {
        var i = 1
        var hashFound = false
        while !hashFound {
            let potentialKey = "\(key)\(i)"
            let md5 = self.calculateMD5(string: potentialKey)
            if self.isValidHash(hash: md5, strict: strict) {
                hashFound = true
            } else {
                i += 1
            }
        }
        
        return i
    }
    
    private func isValidHash(hash: String, strict: Bool) -> Bool {
        let prefix = strict ? "000000" : "00000"
        return hash.hasPrefix(prefix)
    }
    
    private func calculateMD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    
    func solveFirst() {
        let index = self.findFirstMD5(for: self.input, strict: false)
        self.setSolution(challenge: 0, text: "\(index)")
    }
    
    func solveSecond() {
        let index = self.findFirstMD5(for: self.input, strict: true)
        self.setSolution(challenge: 1, text: "\(index)")
    }
}
