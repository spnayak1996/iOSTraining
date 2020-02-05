import Foundation

func printDictionary<T,S>(_ dict: [T:S]) {
    var string = ""
    for (key,value) in dict {
        string += "\"\(key)\" => \(value); "
    }
    print(string)
}

func updateCharFreqDict(_ dict: inout [Character: Int], _ char: Character) {
    dict[char] = (dict[char] ?? 0) + 1
}

func printFrequencies<T>(_ input: T) {
    var dict = [Character: Int]()
    if let string = input as? String {
        for char in string.lowercased() {
            updateCharFreqDict(&dict, char)
        }
    } else if let array = input as? [String] {
        for string in array {
            for char in string.lowercased() {
                updateCharFreqDict(&dict, char)
            }
        }
    } else {
        print("Invalid Input: Enter a string or array of strings")
    }
    printDictionary(dict)
}

printFrequencies("Sarthak Pattanayak")
printFrequencies(["Sarthak Pattanayak","Satish Chauhan"])
