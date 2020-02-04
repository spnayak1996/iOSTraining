import Foundation

func printDictionary<T,S>(_ dict: [T:S]) {
    var string = ""
    for (key,value) in dict {
        string += "\"\(key)\" => \(value); "
    }
    print(string)
}

func createFrequencyDict(_ string: String) -> [Character: Int] {
    var dict = [Character: Int]()
    for char in string {
        dict[char] = (dict[char] ?? 0) + 1
    }
    return dict
}

func createFrequencyDict(_ array: [String]) -> [Character: Int] {
    var dict = [Character: Int]()
    for string in array {
        for char in string {
            dict[char] = (dict[char] ?? 0) + 1
        }
    }
    return dict
}

func printFrequencies(string: String) {
    let dict = createFrequencyDict(string)
    printDictionary(dict)
}

func printFrequencies(array: [String]) {
    let dict = createFrequencyDict(array)
    printDictionary(dict)
}

printFrequencies(string: "Sarthak Pattanayak")
print()
printFrequencies(array: ["Sarthak Pattanayak","Satish Chauhan"])
