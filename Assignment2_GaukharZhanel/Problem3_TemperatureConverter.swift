// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem3_TemperatureConverter.swift
// Goal: Convert temperature between C/F/K.
// Approach: Read value + unit, convert via small functions, print all three.

import Foundation

func cToF(_ c: Double) -> Double { c * 9/5 + 32 }
func cToK(_ c: Double) -> Double { c + 273.15 }
func fToC(_ f: Double) -> Double { (f - 32) * 5/9 }
func kToC(_ k: Double) -> Double { k - 273.15 }

print("Enter value:", terminator: " ")
let vStr = readLine() ?? ""
print("Enter unit (C/F/K):", terminator: " ")
let uStr = (readLine() ?? "").trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

if let v = Double(vStr) {
    switch uStr {
    case "C":
        let f = cToF(v), k = cToK(v)
        print("Input: \(v) °C")
        print("Fahrenheit: \(String(format: "%.2f", f)) °F")
        print("Kelvin: \(String(format: "%.2f", k)) K")
    case "F":
        let c = fToC(v), k = cToK(fToC(v))
        print("Input: \(v) °F")
        print("Celsius: \(String(format: "%.2f", c)) °C")
        print("Kelvin: \(String(format: "%.2f", k)) K")
    case "K":
        let c = kToC(v), f = cToF(kToC(v))
        print("Input: \(v) K")
        print("Celsius: \(String(format: "%.2f", c)) °C")
        print("Fahrenheit: \(String(format: "%.2f", f)) °F")
    default:
        print("Unknown unit. Use C/F/K.")
    }
} else {
    print("Invalid number.")
}
