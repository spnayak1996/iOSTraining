import Foundation

//for O(n) time complexity
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

//for O(n/2) time complexity

func reverse(array arr: [Int]) -> [Int] {
    var output = arr
    let n = output.count
    for i in 0...( n % 2 == 0 ? (n/2 - 1) : ((n - 1)/2 - 1) ) {
        (output[i],output[n - 1 - i]) = (output[n - 1 - i],output[i])
    }
    return output
}

print(reverse(array: [1,2,3,4,5,6,7,8,9]))
