// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem9_SimpleCalculator.swift
// Goal: Simple calculator: +, -, *, / until user quits.
// Approach: Functions per operation, loop, division-by-zero check.

import Foundation

func add(_ a: Double, _ b: Double) -> Double { a + b }
func sub(_ a: Double, _ b: Double) -> Double { a - b }
func mul(_ a: Double, _ b: Double) -> Double { a * b }
func div(_ a: Double, _ b: Double) -> String { b == 0 ? "Error: Division by zero." : String(a / b) }

while true {
    print("Enter first number (or 'q' to quit):", terminator: " ")
    guard let aStr = readLine(), aStr.lowercased() != "q" else { break }
    guard let a = Double(aStr) else { print("Invalid number."); continue }

    print("Enter second number:", terminator: " ")
    guard let bStr = readLine(), let b = Double(bStr) else { print("Invalid number."); continue }

    print("Choose operation (+, -, *, /):", terminator: " ")
    let op = (readLine() ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

    let result: String
    switch op {
    case "+": result = String(add(a, b))
    case "-": result = String(sub(a, b))
    case "*": result = String(mul(a, b))
    case "/": result = div(a, b)
    default:  result = "Unknown operation."
    }
    print("Result: \(result)")
}
print("Goodbye!")
