//
//  ConfigurationViewController.swift
//  GridProject
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

protocol ConfigurationViewControllerDelegate: UIViewController {
    func setConfiguration(time: Double?, size: Float?, spacing: Float?)
}

class ConfigurationViewController: UIViewController {
    
    static let controllerId = "ConfigurationViewController"
    
    @IBOutlet private weak var txtAnimationTime: UITextField!
    @IBOutlet private weak var txtSize: UITextField!
    @IBOutlet private weak var txtSpacing : UITextField!
    
    private var prefilledValues: (time: String, size: String, spacing: String) = ("","","")
    
    weak var delegate: ConfigurationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setPrefilledValuesToTxtFields()
    }
    
    @IBAction private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setPrefilledValues(time: Double, size: Float, spacing: Float) {
        prefilledValues = (String(time),String(size),String(spacing))
    }
    
    private func setPrefilledValuesToTxtFields() {
        txtAnimationTime.text = prefilledValues.time
        txtSize.text = prefilledValues.size
        txtSpacing.text = prefilledValues.spacing
    }
    
    private func validateAnimationTime(errorString: inout String) -> Double? {
        if let time = Double(txtAnimationTime.text ?? ""), time < 5 {
            return time
        } else {
            errorString.append(contentsOf: "animation time")
            return nil
        }
    }
    
    private func validateSpacing(errorString: inout String) -> Float? {
        if let spacing = Float(txtSpacing.text ?? ""), spacing < Float(self.view.frame.height)/2 {
            return spacing
        } else {
            if !errorString.isEmpty {
                errorString.append(", ")
            }
            errorString.append(contentsOf: "item spacing")
            return nil
        }
    }
    
    private func validateItemSize(errorString: inout String) -> Float? {
        let width = Float(self.view.frame.size.width)
        let height = Float(self.view.frame.size.height)
        if let size = Float(txtSize.text ?? ""), size <= width, size <= height, size >= 30 {
            return size
        } else {
            if !errorString.isEmpty {
                errorString.append(", ")
            }
            errorString.append(contentsOf: "item size")
            return nil
        }
    }
    
    private func showErrorIfAny(errorString: String, time: Double?, spacing: Float?, size: Float?) {
        if errorString.isEmpty {
            delegate?.setConfiguration(time: time, size: size, spacing: spacing)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "invalid \(errorString)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction private func save() {
        var animationTime: Double?
        var itemSpacing: Float?
        var itemSize: Float?
        var errorString = ""
        animationTime = validateAnimationTime(errorString: &errorString)
        itemSpacing = validateSpacing(errorString: &errorString)
        itemSize = validateItemSize(errorString: &errorString)
        showErrorIfAny(errorString: errorString, time: animationTime, spacing: itemSpacing, size: itemSize)
    }

}
