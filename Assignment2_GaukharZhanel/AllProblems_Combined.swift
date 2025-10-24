// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem1_FizzBuzz.swift
// Goal: Print 1...100 with Fizz/Buzz/FizzBuzz rules.
// Approach: Simple for-loop + if/else. Clean and readable.

for n in 1...100 {
    if n % 15 == 0 {
        print("FizzBuzz")
    } else if n % 3 == 0 {
        print("Fizz")
    } else if n % 5 == 0 {
        print("Buzz")
    } else {
        print(n)
    }
}

// --- Combined: All Problems in One File (for teacher's quick review) ---

// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem2_Primes.swift
// Goal: Print all prime numbers from 1 to 100.
// Approach: Helper function isPrime(_:). Check divisors up to sqrt(n).

func isPrime(_ x: Int) -> Bool {
    if x < 2 { return false }
    if x == 2 { return true }
    if x % 2 == 0 { return false }
    let limit = Int(Double(x).squareRoot())
    var d = 3
    while d <= limit {
        if x % d == 0 { return false }
        d += 2
    }
    return true
}

for n in 1...100 {
    if isPrime(n) {
        print(n)
    }
}

// --- Combined: All Problems in One File (for teacher's quick review) ---

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

// --- Combined: All Problems in One File (for teacher's quick review) ---

// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem4_ShoppingList.swift
// Goal: Interactive shopping list: add/remove/show/exit.
// Approach: Array storage + simple text menu in a loop.

import Foundation

var shoppingList: [String] = []

func showMenu() {
    print("\n--- Shopping List ---")
    print("1) Add  2) Remove  3) Show  4) Exit")
    print("Choose (1-4):", terminator: " ")
}

while true {
    showMenu()
    guard let choice = readLine(), let opt = Int(choice) else {
        print("Enter a number 1-4."); continue
    }
    switch opt {
    case 1:
        print("Item to add:", terminator: " ")
        if let item = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !item.isEmpty {
            shoppingList.append(item)
            print("Added: \(item)")
        } else { print("Item cannot be empty.") }
    case 2:
        print("Item to remove:", terminator: " ")
        if let item = readLine() {
            if let idx = shoppingList.firstIndex(of: item) {
                print("Removed: \(shoppingList.remove(at: idx))")
            } else {
                print("Item not found.")
            }
        }
    case 3:
        if shoppingList.isEmpty {
            print("[Empty]")
        } else {
            for (i, it) in shoppingList.enumerated() {
                print("\(i+1). \(it)")
            }
        }
    case 4:
        print("Goodbye!"); break
    default:
        print("Invalid option.")
    }
    if opt == 4 { break }
}

// --- Combined: All Problems in One File (for teacher's quick review) ---

// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem5_WordFrequency.swift
// Goal: Count word frequency in a sentence.
// Approach: Lowercase, strip punctuation, split by spaces, use [String:Int].

import Foundation

print("Enter a sentence:", terminator: " ")
let s = readLine() ?? ""

let allowed = CharacterSet.alphanumerics.union(.whitespaces)
let cleaned = String(s.lowercased().unicodeScalars.filter { allowed.contains($0) })
let words = cleaned.split(whereSeparator: \.isWhitespace).map(String.init)

var freq: [String:Int] = [:]
for w in words { freq[w, default: 0] += 1 }

for (w, c) in freq.sorted(by: { $0.key < $1.key }) {
    print("\(w): \(c)")
}

// --- Combined: All Problems in One File (for teacher's quick review) ---

// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem6_Fibonacci.swift
// Goal: Return first n Fibonacci numbers.
// Approach: Iterative loop, handle n<=0 and n==1.

import Foundation

func fibonacci(_ n: Int) -> [Int] {
    if n <= 0 { return [] }
    if n == 1 { return [0] }
    var a = 0, b = 1
    var out = [a, b]
    while out.count < n {
        let next = a + b
        out.append(next)
        a = b
        b = next
    }
    return out
}

print("Enter n:", terminator: " ")
if let s = readLine(), let n = Int(s) {
    print(fibonacci(n))
} else {
    print("Invalid n.")
}

// --- Combined: All Problems in One File (for teacher's quick review) ---

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

// --- Combined: All Problems in One File (for teacher's quick review) ---

// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem8_Palindrome.swift
// Goal: Check if a string is a palindrome (ignore spaces/punctuation, case-insensitive).
// Approach: Filter to alphanumerics, lowercase, compare with reversed.

import Foundation

func isPalindrome(_ text: String) -> Bool {
    let allowed = CharacterSet.alphanumerics
    let norm = String(text.unicodeScalars.filter { allowed.contains($0) }).lowercased()
    return norm == String(norm.reversed())
}

print("Enter text:", terminator: " ")
let t = readLine() ?? ""
print(isPalindrome(t))

// --- Combined: All Problems in One File (for teacher's quick review) ---

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

// --- Combined: All Problems in One File (for teacher's quick review) ---

// Assignment #2 — Swift Basics: Loops, Conditions, Collections
// Author: Gaukhar Zhanel
// File: Problem10_UniqueCharacters.swift
// Goal: Return true if all characters in a string are unique (case-sensitive).
// Approach: Use a Set<Character> and early exit on duplicate.

import Foundation

func hasUniqueCharacters(_ text: String) -> Bool {
    var seen = Set<Character>()
    for ch in text {
        if seen.contains(ch) { return false }
        seen.insert(ch)
    }
    return true
}

print("Enter text:", terminator: " ")
let s = readLine() ?? ""
print(hasUniqueCharacters(s))
