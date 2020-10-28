//
//  PermutationHelper.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 28/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import Foundation

class PermutationHelper {
    static func allPermutations<T>(_ elements: [T]) -> [[T]] {
        if elements.count == 1 { return [elements] }
        var allResults: [[T]] = []
        for (i, element) in elements.enumerated() {
            var elements = elements
            elements.remove(at: i)
            let permutations = allPermutations(elements)
            let p = permutations.map({ (a: [T]) -> [T] in
                var b = a
                b.insert(element, at: 0)
                return b
            })
            allResults += p
        }
        return allResults
    }
}
