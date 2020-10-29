//
//  Day15VC.swift
//  AdventOfCode2015
//
//  Created by Geir-Kåre S. Wærp on 29/10/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day15VC: AoCVC, AdventDay {
    struct Ingredient: Hashable {
        let name: String
        let capacity: Int
        let durability: Int
        let flavor: Int
        let texture: Int
        let calories: Int
        
        static func from(string: String) -> Ingredient {
            let split = string
                .replacingOccurrences(of: ":", with: "")
                .replacingOccurrences(of: ",", with: "")
                .split(separator: " ")
                .map({String($0)})
            return Ingredient(name: split[0],
                              capacity: Int(split[2])!,
                              durability: Int(split[4])!,
                              flavor: Int(split[6])!,
                              texture: Int(split[8])!,
                              calories: Int(split[10])!)
        }
    }

    private typealias Recipe = [Ingredient : Int] // Ingredient --> Amount
    
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextLines()
    }
    
    func runTests() {
        let testInput = """
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
""".split(separator: "\n").map({String($0)})
        
        let ingredients = testInput.map({Ingredient.from(string: $0)})
        let recipe: Recipe = [ingredients[0] : 44,
                              ingredients[1] : 56]
        let score = self.calculateScore(for: recipe)
        
        assert(score == 62842880)
        
        let recipe2: Recipe = [ingredients[0] : 40,
                               ingredients[1] : 60]
        
        let calories = self.calculateCalories(for: recipe2)
        let score2 = self.calculateScore(for: recipe2)
        assert(calories == 500)
        assert(score2 == 57600000)
    }
    
    private func calculateScore(for recipe: Recipe) -> Int {
        let capacity = recipe.map { $0.capacity * $1}.reduce(0, +).clamp(min: 0)
        let durability = recipe.map { $0.durability * $1}.reduce(0, +).clamp(min: 0)
        let flavor = recipe.map { $0.flavor * $1}.reduce(0, +).clamp(min: 0)
        let texture = recipe.map { $0.texture * $1}.reduce(0, +).clamp(min: 0)
        
        return [capacity, durability, flavor, texture].reduce(1, *)
    }
    
    private func calculateCalories(for recipe: Recipe) -> Int {
        return recipe.map({ $0.calories * $1 }).reduce(0, +)
    }
    
    func solveFirst() {
        let ingredients = self.input.map({Ingredient.from(string: $0)})
        let maxIngredients = 100
        var bestRecipeScore = Int.min
        
        for a in 0...maxIngredients {
            for b in 0...maxIngredients - a {
                for c in 0...maxIngredients - (a + b) {
                    let d = maxIngredients - (a + b + c)
                    let recipe: Recipe = [ingredients[0] : a,
                                          ingredients[1] : b,
                                          ingredients[2] : c,
                                          ingredients[3] : d]
                    
                    let score = self.calculateScore(for: recipe)
                    bestRecipeScore = max(bestRecipeScore, score)
                }
            }
        }
        
        self.setSolution(challenge: 0, text: "\(bestRecipeScore)")
    }
    
    func solveSecond() {
        let ingredients = self.input.map({Ingredient.from(string: $0)})
        let maxIngredients = 100
        let targetCalories = 500
        var bestRecipeScore = Int.min
        
        for a in 0...maxIngredients {
            for b in 0...maxIngredients - a {
                for c in 0...maxIngredients - (a + b) {
                    let d = maxIngredients - (a + b + c)
                    let recipe: Recipe = [ingredients[0] : a,
                                          ingredients[1] : b,
                                          ingredients[2] : c,
                                          ingredients[3] : d]
                    
                    let calories = self.calculateCalories(for: recipe)
                    if calories == targetCalories {
                        let score = self.calculateScore(for: recipe)
                        bestRecipeScore = max(bestRecipeScore, score)
                    }
                }
            }
        }
        
        self.setSolution(challenge: 1, text: "\(bestRecipeScore)")
    }
}
