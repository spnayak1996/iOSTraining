import Foundation

func arrayReverser(array arr: [Int]) -> [Int] {
    if arr.isEmpty {
        return arr
    }
    var reversed = [Int]()
    let n = arr.count
    for i in 1...n {
        reversed.append(arr[n - i])
    }
    return reversed
}

print(arrayReverser(array: [1,2,3,4,5,6,7,8,9]))
