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
    
    weak var delegate: ConfigurationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func save() {
        delegate?.setConfiguration(time: Double(txtAnimationTime.text ?? ""), size: Float(txtSize.text ?? ""), spacing: Float(txtSpacing.text ?? ""))
        self.dismiss(animated: true, completion: nil)
    }

}
