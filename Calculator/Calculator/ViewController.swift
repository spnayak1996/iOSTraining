//
//  ViewController.swift
//  Calculator
//
//  Created by vinsol on 05/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private enum Operation {
        case add, subtract, multiply, divide
        
        func description() -> String {
            switch self {
            case .add:
                return "+"
            case .subtract:
                return "-"
            case .multiply:
                return "x"
            case .divide:
                return "/"
            }
        }
    }
    
    private enum CalculatorElement {
        case val(Int)
        case op(Operation)
        case clear
        case decimal
        case empty
        case equal
    }
    
    @IBOutlet private weak var potraitStack: UIStackView!
    @IBOutlet private weak var lblPotraitResult: UILabel!
    @IBOutlet private weak var landscapeStack: UIStackView!
    @IBOutlet private weak var lblLandscapeResult: UILabel!
    private let potraitDataSource: [CalculatorElement] =    [.clear,.empty,.empty,.equal,.val(1),.val(2),.val(3),.op(.add),.val(4),.val(5),.val(6),.op(.subtract),.val(7),.val(8),.val(9),.op(.multiply),.decimal,.val(0),.empty,.op(.divide)]
    private let landscapeDataSource: [CalculatorElement] = [.clear,.val(1),.val(2),.val(3),.equal,.op(.add),.decimal,.val(4),.val(5),.val(6),.empty,.op(.subtract),.val(0),.val(7),.val(8),.val(9),.op(.divide),.op(.multiply)]
    private var dataSource: [CalculatorElement]!
    
    private var operand1: Double?
    //MARK:- add didset for both display and double
    private var operand1String: String? {
        didSet {
            operand1 = operand1String != nil ? Double(operand1String!) : nil
            operand1StringDisplay = convertToStringResultDisplay(operand1String)
        }
    }
    private var operand1StringDisplay: String?
    private var operand2: Double?
    //MARK:- add didset for both display and double
    private var operand2String: String? {
        didSet {
            operand2 = operand2String != nil ? Double(operand2String!) : nil
            operand2StringDisplay = (operand1String == nil && operand2String == nil) ? "0" : (convertToStringEditableDisplay(operand2String) ?? "")
        }
    }
    private var operand2StringDisplay: String = "0"
    private var operation: Operation?

    override func viewDidLoad() {
        super.viewDidLoad()

        setInitialDataSource()
    }
    
    private func setDataSource() {
        if UIDevice.current.orientation.isLandscape {
            setLandscape()
        } else {
            setPotrait()
        }
    }
    
    private func setInitialDataSource() {
        if self.view.bounds.width > self.view.bounds.height {
            setLandscape()
        } else {
            setPotrait()
        }
    }
    
    private func setLandscape() {
        dataSource = landscapeDataSource
        landscapeStack.isHidden = false
        lblLandscapeResult.isHidden = false
        potraitStack.isHidden = true
        lblPotraitResult.isHidden = true
    }
    
    private func setPotrait() {
        dataSource = potraitDataSource
        potraitStack.isHidden = false
        lblPotraitResult.isHidden = false
        landscapeStack.isHidden = true
        lblLandscapeResult.isHidden = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setDataSource()
    }
    
    private func returnValForButtonClicked(tag: Int) -> CalculatorElement {
        return dataSource[tag]
    }
    
    @IBAction private func btnClicked(sender: UIButton) {
        characterEntered(dataSource[sender.tag])
    }
    
    private func operatorTapped(_ op: Operation) {
        switch (operand1,operation,operand2) {
        case (nil,_,nil):
            return
        case (_,_,nil):
            operation = op
        case (nil,nil,_):
            rePosition()
            operation = op
        default:
            calculateAndUpdate()
            operation = op
        }
    }
    
    private func intTapped(_ val: Int) {
        if operation == nil && operand1String != nil {
            operand1String = nil
            operand2String = nil
        }
        if let currentString = operand2String {
            switch checkSize(currentString) {
            case .decimalExceeded:
                showAlert(message: "Cannot enter more than 10 decimal digits.")
            case .digitsExceeded:
                showAlert(message: "Cannot enter more than 15 digits.")
            case .valid:
                operand2String = currentString + String(val)
            }
        } else {
            operand2String = String(val)
        }
    }
    
    private func decimalTapped() {
        if let currentString = operand2String {
            if !currentString.contains(".") {
                operand2String = currentString + "."
            }
        } else {
            operand2String = "."
        }
    }
    
    private func characterEntered(_ char: CalculatorElement) {
        switch char {
        case .equal:
            calculateAndUpdate()
        case .op(let op):
            operatorTapped(op)
        case .val(let val):
            intTapped(val)
        case .decimal:
            decimalTapped()
        case .empty:
            return
        case .clear:
            clearAll()
        }
        updateResult()
    }
    
    private enum Size {
        case decimalExceeded, digitsExceeded, valid
    }
    
    private func checkSize(_ string: String) -> Size {
        if string.contains(".") {
            if let dotIndex = string.firstIndex(of: ".") {
                if string.count - dotIndex - 1 >= 10 {
                    return .decimalExceeded
                }
            }
            if string.count >= 16 {
                return .digitsExceeded
            }
        } else {
            if string.count >= 15 {
                return .digitsExceeded
            }
        }
        return .valid
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func clearAll() {
        operand1String = nil
        operand2String = nil
        operation = nil
    }
    
    private func updateResult() {
        var displayString = (operand1StringDisplay ?? "")
        displayString += operation != nil ? " \((operation!.description())) " : ""
        displayString += operand2StringDisplay
        lblPotraitResult.text = displayString
        lblLandscapeResult.text = displayString
    }
    
    private func calculateAndUpdate() {
        if let op1 = operand1, let op = operation, let op2 = operand2 {
            var string: String? = nil
            switch op {
            case .add:
                string = String(op1 + op2)
            case .subtract:
                string = String(op1 - op2)
            case .multiply:
                string = String(op1 * op2)
            case .divide:
                string = String(op1 / op2)
            }
            operand1String = string
            operand2String = nil
            operation = nil
        }
    }
    
    private func rePosition() {
        operand1String = operand2String
        operand2String = nil
    }
    
    private func convertToStringResultDisplay(_ val: String?) -> String? {
        guard let numString = val else {
            return nil
        }
        if numString.contains("e") {
            return numString
        } else {
            return Double(numString)?.withCommas()
        }
    }
    
    private func convertToStringEditableDisplay(_ val: String?) -> String? {
        guard let numString = val else {
            return nil
        }
        // MARK: add conversion
        if numString.contains("e") {
            return numString
        } else if let (count,flag) = numString.containsConsecutiveEndZerosAfterDecimal() {
            return addRemovedZerosToEnd(Double(numString)?.withCommas() ?? "", count, flag)
        } else {
            if numString.last == "." {
                return  addDotToEnd(Double(numString)?.withCommas())
            } else {
                return Double(numString)?.withCommas()
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
}

extension Double {
    func withCommas() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        return formatter.string(from: NSNumber(value: self))
    }
    
    func extractInt() -> Int {
        return Int(self)
    }
}

extension String {
    func containsConsecutiveEndZerosAfterDecimal() -> (Int,Bool)? {
        if !self.contains(".") {
            return nil
        }
        var string = self
        var count = 0
        while true {
            let last = string.removeLast()
            if last == "0" {
                count += 1
            } else if last == "." {
                return (count == 0 ? nil : (count,true))
            } else {
                return (count == 0 ? nil : (count,false))
            }
        }
    }
    
    func firstIndex(of element: Character) -> Int? {
        var count = 0
        for i in self {
            if i == element {
                return count
            }
             count += 1
        }
        return nil
    }
}

