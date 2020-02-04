import Foundation

func minMax(_ a: Int, _ b: Int) -> (Int,Int) {
    if a > b {
        return (b,a)
    } else {
        return (a,b)
    }
}

print(minMax(4,-1))
