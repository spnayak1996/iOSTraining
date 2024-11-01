import Foundation

struct Circle {
    public var name: String
    private(set) var radius: Double = 1         //editable stored property(with private setter and public getter
    private let pi = 3.141592                           //non-editabel stored property
    public var perimeter: Double {              //computed properties and public setter
        get {
            return 2 * pi * radius
        }
        set {
            radius = newValue/(2 * pi)
        }
    }
    private var area: Double {                  //private computed property
        get {
            return pi * radius * radius
        }
    }
    
    public func printDescription() {            //function to print description
        print("\"\(name)\" with radius = \(radius), perimeter = \(perimeter), area = \(area)")
    }
}

extension Circle {
    init(radius: Double) {                      //custom initializer
        self.init(name: "unnamed", radius: radius)
    }

    init() {                                    //custom initializer
        self.init(name: "unnamed2", radius: 0.5)
    }
}

let circle0 = Circle()                              //custom initializer
var circle1 = Circle(name: "circle")                //default initializer
var circle2 = Circle(name: "circle2", radius: 3)    //default initializer
var circle3 = Circle(radius: 2)                     //custom initializer

circle0.printDescription()                      //function call
circle1.printDescription()
circle2.printDescription()
circle3.printDescription()

print(circle0.radius)                           //get for variable

circle1.perimeter = 4                           //public set
circle2.perimeter = 20
circle3.perimeter = 40

circle1.printDescription()
circle2.printDescription()
circle3.printDescription()
