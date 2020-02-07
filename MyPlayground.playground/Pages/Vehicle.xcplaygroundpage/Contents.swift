import Foundation

class Vehicle {
    let name: String
    private(set) var price: UInt
    
    init(name: String, price: UInt) {
        self.name = name
        self.price = price
    }
    
    func description() -> String {
        return "name: \(name); price: \(price) INR"
    }
    
    func changePrice(newPrice: UInt) {
        price = newPrice
        print("price has been changed to \(price)")
    }
}

class Bike: Vehicle {
    private let dealer: String
    
    init(name: String, price: UInt, dealer: String) {
        self.dealer = dealer
        super.init(name: name, price: price)
    }
    
    override func description() -> String {
        return "name: \(name); price: \(price) INR; dealer: \(dealer)"
    }
}


let bike1 = Bike(name: "Honda", price: 50_000, dealer: "Vinayak")
print(bike1.description())

let bike2 = Bike(name: "Kawasaki", price: 300_000, dealer: "Ninja")
print(bike2.description())
bike2.changePrice(newPrice: 200_000)
print(bike2.description())
