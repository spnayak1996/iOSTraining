import Foundation

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

if let calculator1 = Calculator(operand1: 4, by: "p", operand2: 5) {    //returns nil because of invalid operator
    calculator1.resultExpression()
}

if let calculator2 = Calculator(operand1: 4, by: "*", operand2: 5) {
    calculator2.getExpression()
    calculator2.resultExpression()
}

var calculator3 = Calculator(operand1: 4.8798, by: "/", operand2: 6)
calculator3?.printOutput()

calculator3?.replaceOperator(by: "o")
calculator3?.changeOperand(34, position: 1)
calculator3?.changeOperand(12, position: 2)
calculator3?.changeOperand(234, position: 0)
calculator3?.resultExpression()

calculator3?.replaceOperator(by: "+")
calculator3?.resultExpression()
