//
//  ViewController.swift
//  Calculator
//
//  Created by vinsol on 05/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
