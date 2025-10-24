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
