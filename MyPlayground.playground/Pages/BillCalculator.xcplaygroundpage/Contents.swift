import Foundation

extension Double {
    func roundTo2Decimal() -> Double {
        return (self * 100).rounded()/100
    }
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
    private(set) var name: String                   //name is unique
    private(set) var imported: Bool
    private(set) var price: Double
    private var category: Category
    
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
        return tax
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

class Cart {
    private var shoppingCart: [Product: Int]
    
    static let cart = Cart()
    
    private init() {
        self.shoppingCart = [Product: Int]()
    }
    
    func add(_ product: Product) {
        if Utils.updateDict(&(Cart.cart.shoppingCart), product, 1) {
            print("\(product.name) successfully added to cart.")
        } else {
            print("\(product.name) could not be added to cart.")
        }
    }
    
    func remove(_ product: Product) {
        if Utils.updateDict(&(Cart.cart.shoppingCart), product, -1) {
            print("\(product.name) successfully removed from cart.")
        } else {
            print("\(product.name), No such product in cart.")
        }
    }
    
    func printBill() {
        print()
        print("name      price      qty      tax")
        let shoppingCart = Cart.cart.shoppingCart
        var total: Double = 0
        for key in shoppingCart.keys.sorted(by: { $0.name < $1.name }) {
            if let qty = shoppingCart[key] {
                let tax = key.calculateTax()
                total += (key.price + tax) * Double(qty)
                print("\(key.name)      \(key.price)      \(qty)      \(tax)")
            }
        }
        print("Total = \(total.rounded())")
        print()
    }
}

//test
let stationery = Category(name: "Stationery")


let product1 = Product(name: "Resnik", imported: false, price: 5000, categoryName: "Book")
let product2 = Product(name: "Pen", imported: true, price: 500, category: stationery)
let product3 = Product(name: "Candy", imported: true, price: 100.456, categoryName: "Food")
let product4 = Product(name: "Cetzine", imported: false, price: 150.557, categoryName: "Medicine")


let cart = Cart.cart
cart.add(product1)
cart.remove(product4)
cart.printBill()
cart.add(product2)
cart.add(product3)
cart.add(product4)
cart.add(product2)
cart.add(product4)
cart.add(product1)
cart.remove(product2)
cart.printBill()
cart.add(product1)
cart.add(product2)
cart.add(product4)
cart.add(product1)
cart.printBill()
