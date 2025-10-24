
// Assignment #1: Your Life Story in Swift
// Author: Gaukhar Zhanel

// Step 1: Personal Information
var firstName: String = "Gaukhar"
var lastName: String = "Zhanel"
let birthYear: Int = 2004
let currentYear: Int = 2025
var age: Int = currentYear - birthYear
var isStudent: Bool = true
var university: String = "Kazakh-British Technical University"
var height: Double = 1.67

// Step 2: Hobbies and Interests
var hobby1: String = "drawing"
var hobby2: String = "traveling"
var numberOfHobbies: Int = 2
var favoriteNumber: Int = 8
var isHobbyCreative: Bool = true

// Step 3: Create a Summary of Your Life Story
var lifeStory: String = "My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear). I am currently a student at \(university). I enjoy \(hobby1) and \(hobby2). \(hobby1.capitalized) is a creative hobby: \(isHobbyCreative). I have \(numberOfHobbies) hobbies in total, and my favorite number is \(favoriteNumber)."

// Step 4: Future Goals (Bonus Task)
var futureGoals: String = "In the future, I want to move abroad and use my skills there."

// Combine everything into one final string
lifeStory += " \(futureGoals)"

// Step 5: Print Your Life Story
print(lifeStory)
