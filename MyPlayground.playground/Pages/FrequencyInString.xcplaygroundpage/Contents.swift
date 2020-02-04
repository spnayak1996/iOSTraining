import Foundation

func printDictionary<T,S>(_ dict: [T:S]) {
    for (key,value) in dict {
        print("\"\(key)\" => \(value)")
    }
}

func createFrequencyDict(_ string: String) -> [Character: Int] {
    var dict = [Character: Int]()
    for char in string {
        dict[char] = (dict[char] ?? 0) + 1
    }
    return dict
}

func printFrequencies(_ string: String) {
    let dict = createFrequencyDict(string)
    printDictionary(dict)
}

printFrequencies("Sarthak Pattanayak")
