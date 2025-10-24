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
