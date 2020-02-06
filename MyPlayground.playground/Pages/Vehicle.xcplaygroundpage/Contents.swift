import Foundation

class Vehicle {
    private(set) var name: String
    var price: UInt
    
    init(name: String, price: UInt) {
        self.name = name
        self.price = price
    }
    
    init() {
        self.name = "default"
        self.price = 0
    }
    
    func printDescription() {
        print("name: \(name); price: \(price) INR")
    }
    
    func changePrice(newPrice: UInt) {
        price = newPrice
        print("price has been changed to \(price)")
    }
}

class Bike: Vehicle {
    private var dealer: String
    
    init(name: String, price: UInt, dealer: String) {
        self.dealer = dealer
        super.init(name: name, price: price)
    }
    
    override init() {
        self.dealer = "default"
        super.init()
    }
    
    override func printDescription() {
        print("name: \(name); price: \(price) INR; dealer: \(dealer)")
    }
}


let bike1 = Bike()
bike1.printDescription()

let bike2 = Bike(name: "Kawasaki", price: 300_000, dealer: "Ninja")
bike2.printDescription()
bike2.price = 200_000
bike2.printDescription()
