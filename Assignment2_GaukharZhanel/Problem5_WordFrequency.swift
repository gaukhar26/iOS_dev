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
