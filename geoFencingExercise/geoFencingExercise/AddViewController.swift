//
//  AddViewController.swift
//  GeoFencing
//
//  Created by vinsol on 09/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddViewController: UIViewController {
    
    static let controllerId = "AddViewController"

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var txtViewNote: UITextView! {
        didSet {
            txtViewNote.delegate = self
        }
    }
    @IBOutlet private weak var txtRadius: UITextField! {
        didSet {
            txtRadius.delegate = self
        }
    }
    @IBOutlet private weak var vwEntry: UIView!
    @IBOutlet private weak var vwCheckedEntry: RoundView!
    @IBOutlet private weak var vwExit: UIView!
    @IBOutlet private weak var vwCheckedExit: RoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addToolbar()
    }
    
    private func addToolbar() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtViewNote.inputAccessoryView = numberToolbar
    }
    
    @objc private func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction private func currentLocation(_ sender: UIButton) {
    }
    
    @IBAction private func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveBtnTapped(_ sender: UIButton) {
    }
}

extension AddViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
