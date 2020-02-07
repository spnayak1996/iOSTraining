import Foundation

class Food {
    var name: String
    init(name: String) {
//        print("A")
        self.name = name
//        print("a")
    }
    convenience init() {
//        print("B")
        self.init(name: "[Unnamed]")
//        print("b")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
//        print("C")
        self.quantity = quantity
        super.init(name: name)
//        print("c")
    }
    override convenience init(name: String) {
//        print("D")
        self.init(name: name, quantity: 1)
//        print("d")
    }
}

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = purchased ? "✔ " : "✘ "
        output += "\(quantity) x \(name)"
        return output
    }
}

//let random = RecipeIngredient()
//print(random.name, random.quantity)

//var breakfastList = [
//    ShoppingListItem(),
//    ShoppingListItem(name: "Bacon"),
//    ShoppingListItem(name: "Eggs", quantity: 6),
//]
//breakfastList[0].name = "Orange juice"
//breakfastList[0].purchased = true
//for item in breakfastList {
//    print(item.description)
//}

class Quadrilateral {
    var name: String
    var side1: Int
    var side2: Int
    var side3: Int
    var side4: Int
    var perimeter: Int {
        return (side1 + side2 + side3 + side4)
    }
    
    init(name: String, side1: Int, side2: Int, side3: Int, side4: Int) {
        self.name = name
        self.side1 = side1
        self.side2 = side2
        self.side3 = side3
        self.side4 = side4
    }
    
    convenience init(side1: Int, side2: Int, side3: Int, side4: Int) {
        self.init(name: "[unnnamed]", side1: side1, side2: side2, side3: side3, side4: side4)
    }
}

class Rectangle: Quadrilateral {
    var area: Int {
        print("getting area")
        return side1 * side2
    }
    convenience init(side1: Int, side2: Int) {
        self.init(name: "Rectangle", side1: side1, side2: side2, side3: side1, side4: side2)
    }
}

class Square: Rectangle {
    convenience init(side: Int) {
        self.init(name: "Square", side1: side, side2: side, side3: side, side4: side)
    }
}

//let mySquare = Square(side1: 5, side2: 5, side3: 5, side4: 5)
//print(mySquare.name, mySquare.side1, mySquare.side2, mySquare.side3, mySquare.side4, mySquare.area, mySquare.perimeter)
//
//print(type(of: mySquare.area))
//print(mySquare.area)


enum Beverage: CaseIterable {
    case coffee, tea, juice
}

//print(Beverage.allCases, separator: ", ")

enum Planet: Double {
    case mercury = 10, venus, earth, mars, jupiter, saturn, uranus, neptune
}

//print(Planet.mars.rawValue)

indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(a):
        return a
    case let .addition(expression1, expression2):
        return evaluate(expression1) + evaluate(expression2)
    case let .multiplication(expression1, expression2):
        return evaluate(expression1) * evaluate(expression2)
    }
}

//let expression = ArithmeticExpression.multiplication(.addition(.number(5), .number(10)), .number(3))
//print(evaluate(expression))

var test: String? = .none               //.none for optional is same as nil
//print(test)

enum Result<T> {                        //generic associated enum
    case Success(T)
    case Failure(NSError)
}

enum Barcode {
    case UPCA(Int, Int, Int)
    case QRCode(String)
}

extension Barcode: RawRepresentable {           //use RawRepresentable extension on an enum with associated values to hav both

    public typealias RawValue = String

    /// Failable Initalizer
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "Order 1":  self = .UPCA(1,1,1)
        case "Order 2":  self = .QRCode("foo")
        default:
            return nil
        }
    }

    /// Backing raw value
    public var rawValue: RawValue {
        switch self {
        case .UPCA:     return "Order 1"
        case .QRCode:   return "Order 2"
        }
    }

}


