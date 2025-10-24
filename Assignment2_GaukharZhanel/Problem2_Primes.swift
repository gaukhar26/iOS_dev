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
