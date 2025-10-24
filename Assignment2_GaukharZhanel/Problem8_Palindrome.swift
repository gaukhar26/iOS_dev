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
