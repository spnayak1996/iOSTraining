import Foundation

func nthFibonacci(n count: Int64) -> Int64 {
    var fN_1: Int64 = 1
    var fN: Int64 = 2
    
    if count <= 2 {
        return 1
    } else {
        for _ in 1...(count - 2) {
            (fN, fN_1) = (fN + fN_1,fN)
        }
        return fN
    }
}

print(nthFibonacci(n: 91)) // can only calculate till n= 91


