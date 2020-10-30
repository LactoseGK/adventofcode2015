//
//  Day18VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 30/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day18VC: AoCVC, AdventDay {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
    }
    
    private var initialTestState: String {
        return  """
        .#.#.#
        ...##.
        #....#
        ..#...
        #.#..#
        ####..
        """
    }
    
    private var testLayouts: [String] {
        return ["""
        ..##..
        ..##.#
        ...##.
        ......
        #.....
        #.##..
        """,
                    
        """
        ..###.
        ......
        ..###.
        ......
        .#....
        .#....
        """,
                    
        """
        ...#..
        ......
        ...#..
        ..##..
        ......
        ......
        """,
                    
        """
        ......
        ......
        ..##..
        ..##..
        ......
        ......
        """]
    }
    
    private var testLayouts2: [String] {
        return ["""
        #.##.#
        ####.#
        ...##.
        ......
        #...#.
        #.####
        """,
                    
        """
        #..#.#
        #....#
        .#.##.
        ...##.
        .#..##
        ##.###
        """,
                    
        """
        #...##
        ####.#
        ..##.#
        ......
        ##....
        ####.#
        """,
                    
        """
        #.####
        #....#
        ...#..
        .##...
        #.....
        #.#..#
        """,
        
        """
        ##.###
        .##..#
        .##...
        .##...
        #.#...
        ##...#
        """]
    }
    
    func runTests() {
        let arrayed = self.initialTestState.components(separatedBy: "\n")
        let width = 6
        let height = 6
        var values: [Grid.GridValue] = []
        
        for line in arrayed {
            for char in line {
                values.append(String(char))
            }
        }
        var grid = Grid(size: IntPoint(x: width, y: height), values: values)
        assert(grid.asText() == self.initialTestState)
        
        let numTicks = 4
        for i in 0..<numTicks {
            grid = self.tick(grid: grid)
            assert(grid.asText() == self.testLayouts[i])
        }
        
        assert(self.countActive(in: grid) == 4)
        
        
        var grid2 = Grid(size: IntPoint(x: width, y: height), values: values)
        self.forceActiveCorners(grid: grid2)
        
        let numTicks2 = 5
        for i in 0..<numTicks2 {
            grid2 = self.tick(grid: grid2)
            self.forceActiveCorners(grid: grid2)
            assert(grid2.asText() == self.testLayouts2[i])
        }
        
        assert(self.countActive(in: grid2) == 17)
    }
    
    private func tick(grid: Grid) -> Grid {
        let newGrid = Grid(size: grid.size, values: grid.values)
        let neighborOffsets: [IntPoint] = [IntPoint(x: 0, y: 1),
                                           IntPoint(x: 1, y: 1),
                                           IntPoint(x: 1, y: 0),
                                           IntPoint(x: 1, y: -1),
                                           IntPoint(x: 0, y: -1),
                                           IntPoint(x: -1, y: -1),
                                           IntPoint(x: -1, y: 0),
                                           IntPoint(x: -1, y: 1)]
        
        for currentPoint in grid.size.gridPoints() {
            let neighborValues = grid.getValues(offset: currentPoint, offsets: neighborOffsets)
            let currentActive = grid.getValue(at: currentPoint) == "#"
            let numActiveNeighbors = neighborValues.filter({$0 == "#"}).count
            let newActive: Bool
            if currentActive {
                newActive = (numActiveNeighbors == 2) || (numActiveNeighbors == 3)
            } else {
                newActive = (numActiveNeighbors == 3)
            }
            let newValue = newActive ? "#" : "."
            
            newGrid.setValue(at: currentPoint, to: newValue)
        }
        
        return newGrid
    }
    
    private func countActive(in grid: Grid) -> Int {
        grid.size.gridPoints().compactMap({grid.getValue(at: $0)}).filter({$0 == "#"}).count
    }
    
    func solveFirst() {
        let width = 100
        let height = 100
        var values: [Grid.GridValue] = []
        for line in self.input {
            for char in line {
                values.append(String(char))
            }
        }
        
        var grid = Grid(size: IntPoint(x: width, y: height), values: values)
        
        let numTicks = 100
        for _ in 0..<numTicks {
            grid = self.tick(grid: grid)
        }
        
        let numActive = self.countActive(in: grid)
        self.setSolution(challenge: 0, text: "\(numActive)")
    }
    
    func solveSecond() {
        let width = 100
        let height = 100
        var values: [Grid.GridValue] = []
        for (_, line) in self.input.enumerated() {
            for (_, char) in line.enumerated() {
                values.append(String(char))
            }
        }
        
        var grid = Grid(size: IntPoint(x: width, y: height), values: values)
        self.forceActiveCorners(grid: grid)
        let numTicks = 100
        for _ in 0..<numTicks {
            grid = self.tick(grid: grid)
            self.forceActiveCorners(grid: grid)
        }
        
        let numActive = self.countActive(in: grid)
        self.setSolution(challenge: 1, text: "\(numActive)")
    }
    
    private func forceActiveCorners(grid: Grid) {
        let cornerPositions: [IntPoint] = [IntPoint(x: 0, y: 0),
                                           IntPoint(x: 0, y: grid.height - 1),
                                           IntPoint(x: grid.width - 1, y: grid.height - 1),
                                           IntPoint(x: grid.width - 1, y: 0),
        ]
        cornerPositions.forEach({grid.setValue(at: $0, to: "#")})
    }
}
