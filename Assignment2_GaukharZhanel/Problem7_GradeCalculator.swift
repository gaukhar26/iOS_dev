// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem7_GradeCalculator.swift
// Goal: Read student names/scores, average, highest, lowest, above/below avg.
// Approach: Two arrays (names/scores). Loops and simple math.

import Foundation

func readInt(_ prompt: String) -> Int {
    while true {
        print(prompt, terminator: " ")
        if let s = readLine(), let v = Int(s) { return v }
        print("Enter an integer.")
    }
}

let count = readInt("How many students?")
var names: [String] = []
var scores: [Int] = []

for i in 1...count {
    print("Enter name #\(i):", terminator: " ")
    let name = (readLine() ?? "Student\(i)").trimmingCharacters(in: .whitespacesAndNewlines)
    let score = readInt("Enter score for \(name):")
    names.append(name)
    scores.append(score)
}

if names.isEmpty {
    print("No data.")
} else {
    let total = scores.reduce(0, +)
    let avg = Double(total) / Double(scores.count)
    let maxScore = scores.max()!
    let minScore = scores.min()!
    let maxIdx = scores.firstIndex(of: maxScore)!
    let minIdx = scores.firstIndex(of: minScore)!

    print("\nAverage: \(String(format: \"%.2f\", avg))")
    print("Highest: \(names[maxIdx]) — \(maxScore)")
    print("Lowest:  \(names[minIdx]) — \(minScore)\n")

    for (i, name) in names.enumerated() {
        let s = scores[i]
        let status = Double(s) >= avg ? ">= average" : "< average"
        print("\(name): \(s) (\(status))")
    }
}
