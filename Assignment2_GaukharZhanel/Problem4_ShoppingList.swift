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
