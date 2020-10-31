//
//  Day12VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 29/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day12VC: AoCVC, AdventDay, InputLoadable {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    private func countValues(in string: String, ignoring: String? = nil) -> Int {
        let jsonObject = try! JSONSerialization.jsonObject(with: string.data(using: .utf8)!, options: []) as Any
        return self.traverseJSON(node: jsonObject, ignoring: ignoring)
    }
    
    private func traverseJSON(node: Any, ignoring: String?) -> Int {
        if let value = node as? Int {
            return value
        }
        if let array = node as? [Any] {
            return array.map({self.traverseJSON(node: $0, ignoring: ignoring)}).reduce(0, +)
        }
        if let object = node as? [String : Any] {
            if let ignoring = ignoring,
                object.values.contains(where: {$0 as? String == ignoring}) {
                return 0
            }
            return object.values.map({self.traverseJSON(node: $0, ignoring: ignoring)}).reduce(0, +)
        }
        
        return 0
    }
    
    func solveFirst() {
        let result = self.input.map({self.countValues(in: $0)}).reduce(0, +)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.input.map({self.countValues(in: $0, ignoring: "red")}).reduce(0, +)
        self.setSolution(challenge: 1, text: "\(result)")
    }
}

extension Day12VC: TestableDay {
    func runTests() {
        let tests = [#"[1,2,3]"#,
                     #"{"a":2,"b":4}"#,
                     #"[[[3]]]"#,
                     #"{"a":{"b":4},"c":-1}"#,
                     #"{"a":[-1,1]}"#,
                     #"[-1,{"a":1}]"#,
                     #"[]"#,
                     #"{}"#]
        let results = tests.map({self.countValues(in: $0)})
        assert(results == [6, 6, 3, 3, 0, 0, 0, 0])
        
        let tests2 = [#"[1,{"c":"red","b":2},3]"#,
                      #"{"d":"red","e":[1,2,3,4],"f":5}"#,
                      #"[1,"red",5]"#]
        let results2 = tests2.map({self.countValues(in: $0, ignoring: "red")})
        assert(results2 == [4, 0, 6])
    }
}
