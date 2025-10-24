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
