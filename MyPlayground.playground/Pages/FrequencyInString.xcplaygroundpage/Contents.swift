import Foundation

func printDictionary<T,S>(_ dict: [T:S]) {
    var string = ""
    for (key,value) in dict {
        string += "\"\(key)\" => \(value); "
    }
    print(string)
}

func updateCharFreqDict(_ dict: inout [Character: Int], char: Character) {
    dict[char] = (dict[char] ?? 0) + 1
}

func updateCharFreqDict(_ dict: inout [Character: Int], string: String) {
    for char in string {
        updateCharFreqDict(&dict, char: char)
    }
}

func updateCharFreqDict(_ dict: inout [Character: Int], array: [String]) {
    for string in array {
        updateCharFreqDict(&dict, string: string)
    }
}

func printFrequencies<T>(_ input: T) {
    var dict = [Character: Int]()
    switch input {
    case let string as String:
        updateCharFreqDict(&dict, string: string)
    case let array as [String]:
        updateCharFreqDict(&dict, array: array)
    default:
        print("Invalid Input: Enter a string or array of strings")
        return
    }
    printDictionary(dict)
}

printFrequencies("Sarthak Pattanayak")
printFrequencies(["Sarthak Pattanayak","Satish Chauhan"])
