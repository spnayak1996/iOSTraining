import Foundation

/* For a struct, it is not compulsory to provide an initializer. By default, an initializer is provided with properties as argument. Example: */

struct Circle {
    var name: String
    var random: String = "random"
    private(set) var radius: Double = 1
    private let pi = 3.141592
    var perimeter: Double {
        get {
            return 2 * pi * radius
        }
        set {
            radius = newValue/(2 * pi)
        }
    }
    private var area: Double {
        get {
            return pi * radius * radius
        }
    }
    
    public func printDescription() {
        print("\"\(name)\" with radius = \(radius), perimeter = \(perimeter), area = \(area)")
    }
}
/* as the struct Circle does not have a default value for the name, the default init will have that as an argument.*/

let circle1 = Circle(name: "a")
let circle2 = Circle(name: "b", radius: 2)
let circle3 = Circle(name: "c", random: "r")

/* you can also provide custom initializers for struct in the extension. Custom inits need to define the properties that do not have a default value and you may or may not set a value for the properties with default ones.*/

extension Circle {
    init() {
        self.init(name: "unnamed")
    }
}

let circle4 = Circle()

/*As there is no concept of inheritence in structs, the init process is very straightforward. All non-optional properties after init need to have a value may it be default provided value or value provided in the init.*/


/*For a class, there can be 2 kinds of inits: designated & convenience. Designated inits set the values to the properties, but again it is compulsory to set a value for non-optional properties without a deafult value. A designated init must always call one of the designated inits of the superclass after initializing the newly defined properties. Convenience inits are inits that need to call one of the defined inits(convenience or designated) of the class, but ultimately should call one of the designated init of the class. So, designated inits delegate up and convenience inits delegate across. And if a subclass has an init that has the same name and parameters as that of a designated init in the superclass, then there needs to be an override keyword which would notify the compiler that, this init is overriding an init in its superclass. Example: */

class Shape {
    let name: String
    
    init(name: String) {    //designated
        self.name = name
    }
    
    convenience init() {
        self.init(name: "unnamed")
    }
}

class Polygon: Shape {
    var sides: Int
    var test: String {
        get {
            "test"
        }
        set {
            sides = 0
        }
    }
    
    init(name: String, sides: Int) {    //designated
        self.sides = sides
        super.init(name: name)          //delegating up
    }
    
    override init(name: String) {       //overriding init
        self.sides = 0
        super.init(name: name)
    }
    
    convenience init() {                //convenience init
        self.init(name: "unnamed", sides: 0)    //delegating across
    }
    
//    init() {
//        self.sides = 0
//        super.init(name: "unnamed")
//    }
    
}

/* There are 2 phases in an initialization. First, initial values are provided to propetties by the class that introduced it. Second, each class gets to customize the properties further. The first phase ensures that every property has been initialized and the second phase ensures customizability of the properties. There are 4 safety checks:
    1. A designated initializer must ensure that all of the properties introduced by its class are initialized before it delegates up to a superclass initializer.
    2. A designated initializer must delegate up to a superclass initializer before assigning a value to an inherited property.
    3. A convenience initializer must delegate to another initializer before assigning a value to any property.
    4. An initializer cannot call any instance methods, read the values of any instance properties, or refer to self as a value until after the first phase of initialization is complete.*/

class Triangle: Polygon {
    var area: Double
    
    init(name: String, area: Double) {
        self.area = area                //setting value for property introduced by this class
        super.init(name: name)          //calling designated init of superclass
        self.sides = 3                  //customizing  property
    }
}

/*Automatic init inheritance:
 There are 2 rules:
 1. If no designated inits are defined by a class then it automatically inherits all the designated inits of the superclass.
 2. If a class provides implementation of all the designated inits of its superclass(overrides all the designated inits of the superclass) then it automatically inherits all the convenience inits of the superclass. This is also valid if no designated inits are defined, and it automatically inherits all designated inits resulting in it also inherting all the convenience inits. The case of not providing designated inits only arises when the introduced properties have default values or there are no new introduced proterties.*/


class Mystery: Polygon {                //no designated inits
    var mystery: String = "Mystery"
}

let mystery1 = Mystery()                            //calling the convenience init defined in the superclass
print(mystery1.name, mystery1.sides, mystery1.mystery)

let mystery2 = Mystery(name: "name2")               //calling designated init
print(mystery2.name, mystery2.sides, mystery2.mystery)

let mystery3 = Mystery(name: "name3", sides: 1)     //calling designated init
print(mystery3.name, mystery3.sides, mystery3.mystery)


class Surprise: Polygon {           //overriding all the designated inits of the superclass
    var surprise: String
    
    override var test: String {
        get {
            "testing"
        }
        set {
            surprise = "nonsense"
        }
    }
    
    override init(name: String) {
        self.surprise = "Surprise"
        super.init(name: name)
    }
    
    override convenience init(name: String, sides: Int) {
//        self.surprise = "Surprise"
//        super.init(name: name, sides: sides)
        self.init(name: name)
    }
}

let surprise1 = Surprise()              //calling convenience init
print(surprise1.name, surprise1.sides, surprise1.surprise)
