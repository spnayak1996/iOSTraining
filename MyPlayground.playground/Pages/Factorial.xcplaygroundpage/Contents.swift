import Foundation

func factorial(_ n: Int) -> Int64 {
    if n == 1 || n == 0 {
        return 1
    } else if n == 2 {
        return 2
    } else {
        return Int64(n) * factorial(n - 1)
    }
}

print(factorial(20)) // only calculates for n <= 20
