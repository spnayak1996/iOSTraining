import Foundation

extension Int {
    func digitsArray() -> [Int] {
        var output = [Int]()
        var n = self
        while n > 0 {
            output.insert(n % 10, at: 0)
            n /= 10
        }
        return output
    }
}

func factorial(_ n: Int) -> Int {
    if n == 1 || n == 0 {
        return 1
    } else if n == 2 {
        return 2
    } else {
        return n * factorial(n - 1)
    }
}

print(factorial(20)) // only calculates for n <= 20


func factorialForLargeN(_ n: Int) -> [Int] {
    if n == 1 || n == 0 {
        return [1]
    } else if n == 2 {
        return [2]
    } else {
        return product(n, factorialForLargeN(n - 1))
    }
    
}

func product(_ n: Int, _ arr: [Int]) -> [Int] {
    var output = [Int]()
    for digit in n.digitsArray() {
        if output == [] {
            output = productSingleDigit(digit, arr)
        } else {
            output = addVeryLargePositiveInts(output + [0], productSingleDigit(digit, arr))
        }
    }
    return output
}

func productSingleDigit(_ n: Int, _ arr: [Int]) -> [Int] {
    var output = [Int]()
    var carryOver = 0
    let m = arr.count
    for i in 1...m {
        let sum = (n * arr[m - i]) + carryOver
        carryOver = calculateCarryover(&output, sum, isLastDigit: i == m)
    }
    return output
}

func addVeryLargePositiveInts(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
    var output = [Int]()
    var a = arr1
    var b = arr2
    makeEqualSizes(&a, &b)
    var carryOver = 0
    let n = a.count
    for i in 1...n {
        let sum = a[n - i] + b[n - i] + carryOver
        carryOver = calculateCarryover(&output, sum, isLastDigit: i == n)
    }
    return output
}

func calculateCarryover(_ output: inout [Int], _ sum: Int, isLastDigit: Bool) -> Int {
    var carryOver = 0
    if sum > 9 {
        output.insert(sum % 10, at: 0)
        if isLastDigit {
            output.insert(sum/10, at: 0)
        } else {
            carryOver = sum/10
        }
    } else {
        carryOver = 0
        output.insert(sum, at: 0)
    }
    return carryOver
}

func makeEqualSizes(_ a: inout [Int], _ b: inout [Int]) {
    if a.count > b.count {
        b = [Int](repeating: 0, count: (a.count - b.count)) + b
    } else if a.count < b.count {
        a = [Int](repeating: 0, count: (b.count - a.count)) + a
    }
}

func printVeryLargePositiveInt(_ a: [Int]) {
    for i in a {
        print(i, terminator: "")
    }
    print()
}

func printFactorial(_ n: Int) {
    printVeryLargePositiveInt(factorialForLargeN(n))
}

printFactorial(100)

