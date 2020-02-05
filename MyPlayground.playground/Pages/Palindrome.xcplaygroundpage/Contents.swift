import Foundation

extension String {
    func isPalindrome() -> Bool {
        let n = self.count
        for i in 0...(n % 2 == 0 ? (n/2 - 1) : ((n - 1)/2 - 1) ) {
            if self[i] != self[n - 1 - i] {
                return false
            }
        }
        return true
    }
    
    subscript(_ index: Int) -> Character? {
        if index < 0 || index > self.count - 1 {
            return nil
        } else {
            let requiredIndex = self.index(self.startIndex, offsetBy: index)
            return self[requiredIndex]
        }
    }
    
    func trimWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

func checkPalindrome(_ string: String) {
    if string.trimWhiteSpace() == "" {
        print("Please provide an input")
        return
    } else {
        if string.isPalindrome() {
            print("Input string is a palindrome")
        } else {
            print("Input string is not a palindrome")
        }
    }
}

checkPalindrome("abcdefgadft142232241tfdagfedcba")
checkPalindrome("abcdefgadft142232241tfdag3fedcba")
checkPalindrome("  45  54  ")
