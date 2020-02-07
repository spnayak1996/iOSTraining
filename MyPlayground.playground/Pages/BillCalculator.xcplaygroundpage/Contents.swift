import Foundation

extension Double {
    func roundTo2Decimal() -> Double {
        return (self * 100).rounded()/100
    }
}

enum AddRemoveFailure: Error {
    case AddFailure, RemoveFailure
}

struct Utils {
    static func changeValue<T>(_ dict: inout [T: Int], _ key: T, _ change: Int) {
        let newVal = (dict[key] ?? 0) + change
        dict[key] = newVal > 0 ? newVal : nil
    }
    
    static func updateDict<T>(_ dict: inout [T: Int], _ key: T, _ change: Int) -> Bool {
        guard change != 0 else {
            return true
        }
        if dict[key] == nil && change < 0 {
            return false
        }
        changeValue(&dict, key, change)
        return true
    }
}

class Category {
    private(set) var name: String
    private(set) var exempted: Bool = false
    
    init(name: String) {
        self.name = name
        self.exempted = (name == "Book" || name == "Food" || name == "Medicine")
    }
}

class Product {
    let name: String                   //name is unique
    private(set) var imported: Bool
    private(set) var price: Double
    let category: Category
    
    init(name: String, imported: Bool, price: Double, category: Category) {
        self.name = name
        self.imported = imported
        self.price = price.roundTo2Decimal()
        self.category = category
    }
    
    convenience init(name: String, imported: Bool, price: Double, categoryName: String) {
        self.init(name: name, imported: imported, price: price, category: Category(name: categoryName))
    }
    
    func calculateTax() -> Double {
        var tax: Double = 0
        if !self.category.exempted {
            tax += price * 0.1
        }
        if self.imported {
            tax += price * 0.05
        }
        return tax.roundTo2Decimal()
    }
}

extension Product: Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        if lhs.name == rhs.name{
            return true
        } else {
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}

struct ShoppingCart {
    private var shoppingCart: [Product: Int]
    
    init() {
        shoppingCart = [Product: Int]()
    }
    
    mutating func updateCart(_ product: Product, _ n: Int) -> Bool {
        return Utils.updateDict(&shoppingCart, product, n)
    }
    
    func printBill() {
        print()
        print("name      price      qty      tax")
        var total: Double = 0
        for key in shoppingCart.keys.sorted(by: { $0.name < $1.name }) {
            let tax = key.calculateTax()
            total += (key.price + tax) * Double(shoppingCart[key]!)
            print("\(key.name)      \(key.price)      \(shoppingCart[key]!)      \(tax)")
        }
        print("Total = \(total.rounded())")
        print()
    }
}

class Cart {
    private var shoppingCart: ShoppingCart
    
    static let currentCart = Cart()
    
    private init() {
        self.shoppingCart = ShoppingCart()
    }
    
    func add(_ product: Product) throws {
        guard Self.currentCart.shoppingCart.updateCart(product, 1) else {
            throw AddRemoveFailure.AddFailure
        }
    }
    
    func remove(_ product: Product) throws {
        guard Self.currentCart.shoppingCart.updateCart(product, -1) else {
            throw AddRemoveFailure.RemoveFailure
        }
    }
    
    func printBill() {
        Self.currentCart.shoppingCart.printBill()
    }
}

//test
let stationery = Category(name: "Stationery")


let product1 = Product(name: "Resnik", imported: false, price: 5000, categoryName: "Book")
let product2 = Product(name: "Pen", imported: true, price: 500, category: stationery)
let product3 = Product(name: "Candy", imported: true, price: 100.456, categoryName: "Food")
let product4 = Product(name: "Cetzine", imported: false, price: 150.557, category: stationery)


let cart = Cart.currentCart
try cart.add(product1)
//try cart.remove(product4)
cart.printBill()
try cart.add(product2)
try cart.add(product3)
try cart.add(product4)
try cart.add(product2)
try cart.add(product4)
try cart.add(product1)
try cart.remove(product2)
cart.printBill()
try cart.add(product1)
try cart.add(product2)
try cart.add(product4)
try cart.add(product1)
cart.printBill()

