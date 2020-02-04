import Foundation

func nthFibonacciUnsigned(n count: Int) -> UInt64 {//Int64 for count was not required and Int by default only uses 32 bits but Int64 would have increased the range; UInt64 only increases 1 bit so there was not much effect
    var fN_1: UInt64 = 1
    var fN: UInt64 = 2
    
    if count <= 2 {
        return 1
    } else {
        for _ in 1...(count - 2) {
            (fN, fN_1) = (fN + fN_1,fN)
        }
        return fN
    }
}

print(nthFibonacciUnsigned(n: 92)) // can only calculate till n= 92


func nthFibonacci(n count: Int) -> [Int] {
    var fN_1 = [1]
    var fN = [2]
    
    if count <= 2 {
        return [1]
    } else {
        for _ in 1...(count - 2) {
            (fN,fN_1) = (addVeryLargePositiveInts(fN, fN_1),fN)
        }
    }
    return fN
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
        if sum > 9 {
            output.insert(sum % 10, at: 0)
            if i == n {
                output.insert(sum/10, at: 0)
            } else {
                carryOver = sum/10
            }
        } else {
            carryOver = 0
            output.insert(sum, at: 0)
        }
    }
    return output
}

func makeEqualSizes(_ a: inout [Int], _ b: inout [Int]) {
    if a.count > b.count {
        b = [Int](repeating: 0, count: (a.count - b.count)) + b
    } else if a.count < b.count {
        a = [Int](repeating: 0, count: (b.count - a.count)) + a
    }
}

func printVeryLargePositiveInt(_ a: [Int]) {
    var output = ""
    for i in a {
        output += String(i)
    }
    print(output)
}

func printNthFibonacci(n n: Int) {
    printVeryLargePositiveInt(nthFibonacci(n: n))
}

printNthFibonacci(n: 1000) // can only calculate till n= 92
