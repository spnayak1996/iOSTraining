//
//  ViewController.swift
//  Calculator
//
//  Created by vinsol on 05/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    @IBOutlet private weak var lblResult: UILabel!
    @IBOutlet private weak var resultView: UIView!
    let calculator = Calculator.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func elementEntered(_ tag: Int) {
        do {
            let result = try calculator.characterEntered(ButtonElement.from(tag))
            lblResult.text = result
        } catch Calculator.Size.decimalExceeded {
            showAlert(message: Calculator.Size.decimalExceeded.errorMessage())
        } catch Calculator.Size.digitsExceeded {
            showAlert(message: Calculator.Size.digitsExceeded.errorMessage())
        } catch {
            showAlert(message: "Unknown error.")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ViewController: ButtonViewDelegate {
    func buttonTapped(_ tag: Int) {
        elementEntered(tag)
    }
}
