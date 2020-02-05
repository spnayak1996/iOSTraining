import Foundation

class Food {
    var name: String
    init(name: String) {
        print("A")
        self.name = name
        print("a")
    }
    convenience init() {
        print("B")
        self.init(name: "[Unnamed]")
        print("b")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        print("C")
        self.quantity = quantity
        super.init(name: name)
        print("c")
    }
    override convenience init(name: String) {
        print("D")
        self.init(name: name, quantity: 1)
        print("d")
    }
}

//let random = RecipeIngredient()
//print(random.name, random.quantity)

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

let mySquare = Square(side1: 5, side2: 5, side3: 5, side4: 5)
print(mySquare.name, mySquare.side1, mySquare.side2, mySquare.side3, mySquare.side4, mySquare.area, mySquare.perimeter)
