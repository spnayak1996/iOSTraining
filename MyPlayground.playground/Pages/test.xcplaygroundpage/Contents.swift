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

enum Operator: Character {
    case Add = "+"
    case Subtract = "-"
    case Product = "*"
    case Division = "/"
}

extension Double {
    func displayIntVal() -> Any {
        if let intVal = Int(exactly: self) {
            return intVal
        } else {
            return self
        }
    }
}

class Calculator {
    private var operand1: Double
    private var operand2: Double
    private var operation: Operator
    private var result: Double {
        return operate()
    }
    
    init?(operand1: Double,by op: Character, operand2: Double) { //failable init
        if let operation = Operator(rawValue: op) {
            self.operation = operation
        } else {
            print("calculator init failed because of invalid operator.")
            return nil
        }
        self.operand1 = operand1
        self.operand2 = operand2
    }
    
    private func operate() -> Double {
        switch operation {
        case .Add:
            return operand1 + operand2
        case .Subtract:
            return operand1 - operand2
        case .Product:
            return operand1 * operand2
        case .Division:
            return operand1 / operand2
        }
    }
    
    func output() -> Any {
        return result.displayIntVal()
    }
    
    func replaceOperator(by op: Character) {
        if let operation = Operator(rawValue: op) {
            self.operation = operation
            print("operator changed to \(operation.rawValue)")
        } else {
            print("Invalid operator")
        }
    }
    
    func showOperator() {
        print(operation.rawValue)
    }
    
    func printOutput() {
        print(self.output())
    }
    
    func changeOperand(_ val: Double, position: UInt) {
        switch position {
        case 1:
            self.operand1 = val
        case 2:
            self.operand2 = val
        default:
            print("Invalid position")
            break
        }
    }
    
    private func getOperand(_ position: Int) -> Any? {
        switch position {
        case 1:
            return operand1.displayIntVal()
        case 2:
            return operand2.displayIntVal()
        default:
            return nil
        }
    }
    
    func getExpression() {
        print("\(getOperand(1)!) \(operation.rawValue) \(getOperand(2)!)")
    }
    
    func resultExpression() {
        print("\(getOperand(1)!) \(operation.rawValue) \(getOperand(2)!) = \(result)")
    }
}

class NamedCalculator: Calculator {
    var name: String
    
    init?(name: String, operand1: Double, by op: Character, operand2: Double) {
        self.name = name
        super.init(operand1: operand1, by: op, operand2: operand2)
    }
}

//if let calculator1 = Calculator(operand1: 4, by: "p", operand2: 5) {    //returns nil because of invalid operator
//    calculator1.resultExpression()
//}

struct Utils {
    static func checkForValidity(_ side1: Double, _ side2: Double, _ side3: Double) -> Bool {
        let arr = [side1, side2, side3].sorted()
        if arr[2] > arr[0] + arr[1] {
            return true
        } else {
            return false
        }
    }
}

class Triangle {
    var side1: Double
    var side2: Double
    var side3: Double
    
    var area: Double {
        return computeArea()
    }
    
    fileprivate init(a: Double, b: Double, c: Double) {
        self.side1 = a
        self.side2 = b
        self.side3 = c
    }
    
    convenience init?(side1: Double, side2: Double, side3: Double) {
        if Utils.checkForValidity(side1, side2, side3) {
            self.init(a: side1, b: side2, c: side3)
        } else {
            return nil
        }
    }
    
    fileprivate func computeArea() -> Double {
        let s = (side1 + side2 + side3)/2
        let aSquared = s * (s - side1) * (s - side2)
        return sqrt(aSquared * (s - side3))
    }
}

class Equilateral: Triangle {
    init(side: Double) {
        super.init(a: side, b: side, c: side)
    }

    override fileprivate func computeArea() -> Double {
        return (sqrt(3) * side1 * side1) / 4
    }
}

//let t1 = Equilateral(side: 5)
//print(t1.area)

protocol Togglable {
    init()
    
    mutating func toggle()
    
    func description()
}

extension Togglable {
    func description() {
        print("Done")
    }
}

class OnOffSwitch: Togglable {
    var on: Bool
    
    required init() {
        on = false
    }
    
    func toggle() {
        on = !on
    }
    
    func description() {
        print("Hmmm")
    }
}

class Switch: Togglable {
    var button: Bool
    
    required init() {
        button = true
    }
    
    func toggle() {
        button = !button
    }
}

//var arr: [Togglable] = [OnOffSwitch(), Switch()]
//
//for i in arr {
//    i.description()
//    if let onOffSwitch = i as? OnOffSwitch {
//        print(onOffSwitch.on)
//    }
//    if let button = i as? Switch {
//        print(button.button)
//    }
//}

class House {
    var windows:Int = 0

    init(windows:Int) {
        self.windows = windows
    }
}

class Villa: House {
    var hasGarage:Bool = false

    init(windows:Int, hasGarage:Bool) {
        self.hasGarage = hasGarage

        super.init(windows: windows)
    }
}

class Castle: House {
    var towers:Int = 0

    init(windows:Int, towers:Int) {
        self.towers = towers

        super.init(windows: windows)
    }
}

//let house:House = Castle(windows: 200, towers: 4) as House
//print(type(of: house))
//let castle:Castle = house as! Castle
//print(castle.towers)
//print(house === castle)


struct BlackjackCard {

    // nested Suit enumeration
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }

    // nested Rank enumeration
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        struct Values {
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }

    // BlackjackCard properties and methods
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

//let name = BlackjackCard.Suit.clubs

enum Failure: Error {
    case Failure
}

func name1() throws {
    throw Failure.Failure
}

func name2() throws {
    do {
        try name1()
    } catch {
        throw Failure.Failure
    }
}

extension Int {
    static postfix func ++(a: inout Int) {
        a += 1
    }
}

//var a = 4
//a++
//print(a++)
//print(a)


class Random {
    private var a = 0
    
    var b: Int {
        get {
            return a
        }
        set {
            if newValue > 0 {
                a = newValue
            }
        }
    }
}

//let random = Random()
//random.b = 3
//print(random.b)
//random.b = 0
//print(random.b)

//let group = DispatchGroup()
//
//group.enter()
//DispatchQueue.global().async {
//    for i in 0..<100 {
//        print(i)
//    }
//    group.leave()
//}
//group.enter()
//DispatchQueue.global().async {
//
//    for _ in 0..<100 {
//        print("🔵")
//    }
//    group.leave()
//}
//group.enter()
//DispatchQueue.global().async {
//    for _ in 0..<10000 {
//        print("💔")
//    }
//    group.leave()
//}
//
//group.notify(queue: .main) {
//    print("DONE")
//}

let concurrent = DispatchQueue(label: "com.besher.concurrent", attributes: .concurrent)

concurrent.sync {
    for _ in 0..<5 { print("🔵") }
}

concurrent.async {
    for _ in 0..<5 { print("🔴") }
}


