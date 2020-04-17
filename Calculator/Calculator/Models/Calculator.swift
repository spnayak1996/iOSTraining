//
//  Calculator.swift
//  Calculator
//
//  Created by vinsol on 14/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation

class Calculator {
    
    private enum CalculatorElement {
        case val(Double), op(Operation)
    }
    
    private struct Evaluator {
        private struct Stack {
            private var array: [CalculatorElement] = []
            
            func lastElement() -> CalculatorElement {
                return array.last ?? .val(0)
            }
            
            mutating func pop() -> CalculatorElement {
                return array.removeLast()
            }
            
            mutating func push(_ element: CalculatorElement) {
                array.append(element)
            }
            
            func isEmpty() -> Bool {
                return array.isEmpty
            }
            
            func checkSize() -> Bool {
                if array.count > 1 {
                    return true
                } else {
                    return false
                }
            }
            
            mutating func popVal() -> Double? {
                if let element = array.last {
                    guard case .val(let val) = element else {
                        return nil
                    }
                    _ = self.pop()
                    return val
                }
                return nil
            }
            
            mutating func popOp(precedence: Int) -> Operation? {
                if let element = array.last {
                    guard case .op(let op) = element, op.precedence() >= precedence else {
                        return nil
                    }
                    _ = self.pop()
                    return op
                }
                return nil
            }
        }
        
        private var expression: [CalculatorElement]
        var result: Double {
            get {
                return evaluate()
            }
        }
        
        init(expression: [CalculatorElement]) {
            self.expression = expression
        }
        
        private func evaluate() -> Double {
            var stack = Stack()
            var previousOperatorPrecedence = -1
            var currentOperatorPrecedence = 0
            for element in expression {
                if stack.isEmpty() {
                    stack.push(element)
                } else {
                    switch element {
                    case .op(let op):
                        currentOperatorPrecedence = op.precedence()
                        if currentOperatorPrecedence <= previousOperatorPrecedence {
                            evaluateStack(stack: &stack, precedence: currentOperatorPrecedence)
                        }
                        stack.push(element)
                        previousOperatorPrecedence = currentOperatorPrecedence
                    case .val(_):
                        stack.push(element)
                    }
                }
            }
            evaluateStack(stack: &stack, precedence: 0)
            return stack.popVal() ?? 0
        }
        
        private func evaluateStack(stack: inout Stack, precedence: Int) {
            while stack.checkSize() {
                if let val2 = stack.popVal() {
                    if let op = stack.popOp(precedence: precedence) {
                        if let val1 = stack.popVal() {
                            stack.push(.val(simpleEvaluation(val1: val1, operation: op, val2: val2)))
                        }
                    } else {
                        addBackToStack(stack: &stack, array: [.val(val2)])
                        return
                    }
                }
            }
        }
        
        private func addBackToStack(stack: inout Stack, array: [CalculatorElement]) {
            for element in array {
                stack.push(element)
            }
        }
        
        private func simpleEvaluation(val1: Double, operation: Operation, val2: Double) -> Double {
            switch operation {
            case .add:
                return val1 + val2
            case .subtract:
                return val1 - val2
            case .multiply:
                return val1 * val2
            case .divide:
                return val1 / val2
            }
        }
    }
    
    static let standard = Calculator()
    
    private var expression = [CalculatorElement]()
    private var entryString: String = "" {
        didSet {
            resultString = convertToStringEditableDisplay(entryString) ?? "0"
            if !entryString.isEmpty {
                currentElement = .val(Double(entryString) ?? 0)
            }
        }
    }
    private var currentElement: CalculatorElement = .val(0)
    private var resultString: String = "0"
    
    private init() {
        expression = [CalculatorElement]()
        entryString = ""
        currentElement = .val(0)
    }
    
    private func operatorTapped(_ op: Operation) {
        switch currentElement {
        case .op(_):
            currentElement = .op(op)
        case .val(_):
            expression.append(currentElement)
            currentElement = .op(op)
        }
//        resultString = op.description()
    }

    private func intTapped(_ val: Int) -> Size? {
        switch currentElement {
        case .val(_):
            if let error = checkSize(entryString) {
                return error
            } else {
                entryString.append("\(val)")
            }
        case .op(_):
            expression.append(currentElement)
            entryString = "\(val)"
        }
        return nil
    }

    private func decimalTapped() {
        if !entryString.isEmpty {
            if !entryString.contains(".") {
                entryString = entryString + "."
            }
        } else {
            entryString = "0."
        }
    }
    
    private func clearAll() {
        expression = []
        entryString = ""
        currentElement = .val(0)
    }
    private func trimExpression() {
        if let last = expression.last {
            switch last {
            case .op(_):
                _ = expression.removeLast()
            default:
                break
            }
        }
        if let first = expression.first {
            switch first {
            case .op(_):
                _ = expression.removeFirst()
            default:
                break
            }
        }
    }
    
    private func displayResult() {
        expression.append(currentElement)
        trimExpression()
        let evaluator = Evaluator(expression: expression)
        clearAll()
        let result = evaluator.result
        let stringResult = String(evaluator.result)
        entryString = result.toEntryStringFormat() ?? ""
        resultString = convertToStringResultDisplay(stringResult) ?? "Error"
    }

    func characterEntered(_ char: ButtonElement) throws -> String {
        switch char {
        case .equal:
            displayResult()
        case .op(let op):
            operatorTapped(op)
        case .val(let val):
            if let error = intTapped(val) {
                throw error
            }
        case .decimal:
            decimalTapped()
        case .clear:
            clearAll()
        default:
            break
        }
        return resultString
    }

    
    private func convertToStringResultDisplay(_ val: String) -> String? {
        guard !val.isEmpty else {
            return "0"
        }
        if val.contains("e") {
            return val
        } else {
            return Double(val)?.withCommas()
        }
    }
    
    private func convertToStringEditableDisplay(_ val: String) -> String? {
        guard !val.isEmpty else {
            return "0"
        }
        if val.contains("e") {
            return val
        } else if let (count,flag) = val.containsConsecutiveEndZerosAfterDecimal() {
            return addRemovedZerosToEnd(Double(val)?.withCommas() ?? "", count, flag)
        } else {
            if val.last == "." {
                return  addDotToEnd(Double(val)?.withCommas())
            } else {
                return Double(val)?.withCommas()
            }
        }
    }
    
    private func addDotToEnd(_ string: String?) -> String? {
        if string != nil {
            return string! + "."
        }
        return "."
    }
    
    private func addRemovedZerosToEnd(_ string: String, _ count: Int, _ flag: Bool) -> String {
        return string + (flag ? "." : "") + String(repeating: "0", count: count)
    }
    
    enum Size: Error {
        case decimalExceeded, digitsExceeded
        
        func errorMessage() -> String {
            switch self {
            case .decimalExceeded:
                return "cannot enter more then 8 decimal digits."
            case .digitsExceeded:
                return "cannot enter more then 15 digits"
            }
        }
    }
    
    private func checkSize(_ string: String) -> Size? {
        if string.contains(".") {
            if string.count >= 16 {
                return .digitsExceeded
            }
            if let dotIndex = string.firstIndex(of: ".") {
                if string.count - dotIndex - 1 >= 8 {
                    return .decimalExceeded
                }
            }
        } else {
            if string.count >= 15 {
                return .digitsExceeded
            }
        }
        return nil
    }
}
