import Foundation

func makeIncrementer(increment n: Int) -> (Int) -> Int {
    let incrementer = { (value) in
        return value + n
    }
    return incrementer
}

let tenIncrementer = makeIncrementer(increment: 10)
print(tenIncrementer(23))

let sevenIncrementer = makeIncrementer(increment: 7)
print(sevenIncrementer(67))
