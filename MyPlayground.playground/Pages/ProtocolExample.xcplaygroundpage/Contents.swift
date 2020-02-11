import Foundation

/* Swift does not allow multiple inheritence in classes, meaning a class cannot have more than 1 superclass. This limits flexibility. Example:*/

class Bird{
    
    var name:String
    var feathers:String
    
    func fly(){
        print("I believe i can fly")
    }
    
    init(name:String, feathers:String){
        self.name = name
        self.feathers = feathers
    }
}

class Parrot:Bird{
    
    override init(name: String, feathers: String) {
        super.init(name: name, feathers: feathers)
    }
    
    override func fly() {
        print("I can fly.")
    }
}

class Eagle:Bird{
    
    override init(name: String, feathers: String) {
        super.init(name: name, feathers: feathers)
    }

    override func fly() {
        print("I can fly very high.")
    }
}

class Penguin:Bird{
    
    //now I do not want feathers property in this class, but it is now compulsory because of the superclass
    override init(name: String, feathers: String) {
        super.init(name: name, feathers: feathers)
    }

    //I also donot want the fly function here
    override func fly() {
    }
}

/* To solve this we could simply create 3 protocols namely: Bird, Flyable, Featherable like as follows:*/


protocol Bird2{
    var name:String {get set}
}

protocol Flyable2{
    func fly()
}
extension Flyable2{
    func fly(){
        print("I believe i can fly")
    }
}

protocol Featherable2{
    var feathers:String { get }
}
extension Featherable2{
    var feathers:String {
        get{
            return "I have feather"
        }
    }
}

/* Now mt implementation becomes less cumbersome and easy to modify and flexible. The revised implementation is as folows:*/

struct Parrot2:Bird2, Flyable2, Featherable2{
    var name: String
    
    init(name: String){
        self.name = name
    }
    
    func fly() {
        print("I can fly.")
    }
    
    var feathers: String {
        return "I have green feathers."
    }
}

struct Eagle2:Bird2, Flyable2, Featherable2 {
    var name: String
    
    init(name:String){
        self.name = name
    }
    
    func fly() {
        print("I can fly very high.")
    }
    
    var feathers: String {
        return "I have grey feathers."
    }
}

struct Penguin2:Bird2 {
    var name: String
    
    init(name:String){
        self.name = name
    }
}

/* protools can make life easier when handling multiple disjoint properties with need of very high flexibility. Protocols also hlp unify many different objects into one functionality for simpler implementation. In other words, protocols canhelp reduce complexity that may arise while only use of classes.*/
