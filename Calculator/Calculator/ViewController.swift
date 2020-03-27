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
        
        func represtation() -> String {
            switch self {
            case .val(let val):
                return String(val)
            case .op(let op):
                return op.description()
            case .clear:
                return "AC"
            case .decimal:
                return "."
            case .equal:
                return "="
            default:
                return ""
            }
        }
    }
    
    typealias Colors = (bgColor: UIColor, txtColor: UIColor)
    private struct buttonAttributes {
        static let white: Colors = (#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        static let dark: Colors = (#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        static let yellow: Colors = (#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
    
    @IBOutlet private weak var lblOp1: UILabel!
    @IBOutlet private weak var lblOperator: UILabel!
    @IBOutlet private weak var lblOp2: UILabel!
    @IBOutlet private weak var resultView: UIView!
    private var buttonsStackView: UIStackView!
    private let potraitDataSource: [(CalculatorElement,Colors)] =    [(.clear,buttonAttributes.white),(.empty,buttonAttributes.white),(.empty,buttonAttributes.white),(.equal,buttonAttributes.yellow),(.val(1),buttonAttributes.dark),(.val(2),buttonAttributes.dark),(.val(3),buttonAttributes.dark),(.op(.add),buttonAttributes.yellow),(.val(4),buttonAttributes.dark),(.val(5),buttonAttributes.dark),(.val(6),buttonAttributes.dark),(.op(.subtract),buttonAttributes.yellow),(.val(7),buttonAttributes.dark),(.val(8),buttonAttributes.dark),(.val(9),buttonAttributes.dark),(.op(.multiply),buttonAttributes.yellow),(.decimal,buttonAttributes.dark),(.val(0),buttonAttributes.dark),(.empty,buttonAttributes.dark),(.op(.divide),buttonAttributes.yellow)]
    private let landscapeDataSource: [(CalculatorElement,Colors)] = [(.clear,buttonAttributes.white),(.val(1),buttonAttributes.dark),(.val(2),buttonAttributes.dark),(.val(3),buttonAttributes.dark),(.equal,buttonAttributes.yellow),(.op(.add),buttonAttributes.yellow),(.decimal,buttonAttributes.dark),(.val(4),buttonAttributes.dark),(.val(5),buttonAttributes.dark),(.val(6),buttonAttributes.dark),(.empty,buttonAttributes.yellow),(.op(.subtract),buttonAttributes.yellow),(.val(0),buttonAttributes.dark),(.val(7),buttonAttributes.dark),(.val(8),buttonAttributes.dark),(.val(9),buttonAttributes.dark),(.op(.divide),buttonAttributes.yellow),(.op(.multiply),buttonAttributes.yellow)]
    private var dataSource: [(CalculatorElement,Colors)]!
    
    private var operand1: Double?
    private var operand1String: String? {
        didSet {
            operand1 = operand1String != nil ? Double(operand1String!) : nil
            operand1StringDisplay = convertToStringResultDisplay(operand1String)
        }
    }
    private var operand1StringDisplay: String?
    private var operand2: Double?
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
        //MARK: to be added
        removeAlreadySetStack()
        setStackView(rows: 3, columns: 6)
    }
    
    private func setPotrait() {
        dataSource = potraitDataSource
        //MARK: to be added
        removeAlreadySetStack()
        setStackView(rows: 5, columns: 4)
    }
    
    private func removeAlreadySetStack() {
        if buttonsStackView != nil {
            buttonsStackView.removeFromSuperview()
            buttonsStackView = nil
        }
    }
    
    private func setStackView(rows: Int, columns: Int) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        for row in 0..<rows {
            let rowStackView = setSingleLineStackView(row: row, columns: columns)
            stackView.addArrangedSubview(rowStackView)
        }
        buttonsStackView = stackView
        self.view.addSubview(buttonsStackView)
        setConstraintsForStackView(rows: rows, columns: columns)
    }
    
    private func setSingleLineStackView(row: Int, columns: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        let startIndex = row * columns
        for index in 0..<columns {
            if let view = ButtonView.loadViewFromNib(owner: self) {
                let finalIndex = startIndex + index
                let data = dataSource[finalIndex]
                view.setUp(index: finalIndex, text: data.0.represtation(), bgColor: data.1.bgColor, txtColor: data.1.txtColor)
                view.delegate = self
                stackView.addArrangedSubview(view)
            }
        }
        return stackView
    }
    
    private func setConstraintsForStackView(rows: Int, columns: Int) {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        let heightForStack = getPotraitWidth() * (CGFloat(rows) / CGFloat(columns))
        if rows == 5 && heightForStack < getPotraitHeight() - 170 {
            buttonsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: heightForStack).isActive = true
        } else {
            buttonsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: getPotraitHeight() - 165).isActive = true
        }
        buttonsStackView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 0).isActive = true
    }
    
    private func getPotraitWidth() -> CGFloat {
        return min(self.view.frame.width, self.view.frame.height)
    }
    
    private func getPotraitHeight() -> CGFloat {
        return max(self.view.frame.width, self.view.frame.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setDataSource()
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
        resetOperandsAfterEqual()
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
    
    private func resetOperandsAfterEqual() {
        if operation == nil && operand1String != nil {
            operand1String = nil
            operand2String = nil
        }
    }
    
    private func decimalTapped() {
        resetOperandsAfterEqual()
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
        if let op1 = operand1StringDisplay, (operand2StringDisplay == "0" || operand2StringDisplay == "") && operation == nil {
            lblOp2.text = op1
            lblOp1.text = nil
            lblOperator.text = nil
        } else {
            lblOp1.text = (operand1StringDisplay ?? "")
            lblOperator.text = operation != nil ? " \((operation!.description())) " : ""
            lblOp2.text = operand2StringDisplay
        }
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

extension ViewController: ButtonViewDelegate {
    func buttonTapped(_ index: Int) {
        characterEntered(dataSource[index].0)
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

