import Foundation

extension String {
    func isPalindrome() -> Bool {
        let n = self.count
        for i in 0...(n - 1) {
            let frontIndex = self.index(self.startIndex, offsetBy: i)
            let backIndex = self.index(self.startIndex, offsetBy: (n - 1 - i))
            if self[frontIndex] != self[backIndex] {
                return false
            }
        }
        return true
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

func checkPalindrome(_ string: String) {
    if string.trim() == "" {
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
