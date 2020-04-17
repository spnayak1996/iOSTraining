//
//  Enums.swift
//  Calculator
//
//  Created by vinsol on 17/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation

enum Operation {
    case add, subtract, multiply, divide
    
    func description() -> String {
        switch self {
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .multiply:
            return "×"
        case .divide:
            return "÷"
        }
    }
    
    func precedence() -> Int {
        switch self {
        case .add, .subtract:
            return 0
        case .multiply:
            return 1
        case .divide:
            return 2
        }
    }
}

enum ButtonElement {
    case val(Int)
    case op(Operation)
    case clear
    case decimal
    case empty
    case equal
    
    func representation() -> String {
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
    
    static func from(_ tag: Int) -> ButtonElement {
        switch tag {
        case 0,1,2,3,4,5,6,7,8,9:
            return .val(tag)
        case 10:
            return .decimal
        case 11:
            return .op(.add)
        case 12:
            return .op(.subtract)
        case 13:
            return .op(.multiply)
        case 14:
            return .op(.divide)
        case 15:
            return .equal
        case 16:
            return .clear
        default:
            return .empty
        }
    }
}
