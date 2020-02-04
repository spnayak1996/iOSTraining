import UIKit
import Foundation

func checkIfPrime(num: Int, primesList: [Int]) -> Bool {//func to check if the given number is prime
    for prime in primesList {
        if prime > Int(pow(Double(num),0.5)) {
            break
        } else {
            if num % prime == 0 {
                return false
            }
        }
    }
    return true
}

func createPrimeList(n: Int) -> [Int] {//creates list of first n primes
    var primes = [2]
    
    var current = 3
    while (primes.count < n) {
        if checkIfPrime(num: current, primesList: primes) {
            primes.append(current)
        }
        current += 1
    }
    
    return primes
}

func printPrimes(count n: Int) { //the function to be called to print primes
    guard n > 0  else {
        print("Invalid input")
        return
    }
    print(createPrimeList(n: n))
}

printPrimes(count: 1000)


