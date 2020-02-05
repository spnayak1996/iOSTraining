import Foundation


class Circle {
    public var radius: Double              //stored property editable (variable)
    let pi = 3.141592               //stored property non-editable (constant)
    public var area: Double {              //computed property with both get and set
        get {
            return pi * radius * radius
        }
        set(newArea) {
            radius = (newArea/pi).squareRoot()
        }
    }
    private var perimeter: Double {         //computed property with only get
        return 2 * pi * radius
    }
    
    init(radius: Double) {          //initializer(designated)
        self.radius = radius
    }
    
    convenience init() {            //initializer(convenience)
        self.init(radius: 1)
    }
    
    public func printDescription() {       //function that prints radius, perimeter and area
        print("A circle with radius = \(radius), perimeter = \(self.perimeter), area = \(self.area)")
    }
}

let circle1 = Circle()               //convenience init called
let circle2 = Circle(radius: 2.5)    //designated init called

circle1.printDescription()           //function call
circle2.printDescription()

circle1.area = 15

print(circle1.radius, circle2.radius)//call to variable


