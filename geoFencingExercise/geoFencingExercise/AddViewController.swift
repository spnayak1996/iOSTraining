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
    private var pin: CustomPin!
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
    private var monitoredState = MonitoredState.entry
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addToolbar()
        setTapGesture()
        setEntryExitViewTaps()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    private func setEntryExitViewTaps() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(entryOrExitViewSelected(_:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(entryOrExitViewSelected(_:)))
        vwEntry.addGestureRecognizer(tapGesture1)
        vwExit.addGestureRecognizer(tapGesture2)
    }
    
    private func addToolbar() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtViewNote.inputAccessoryView = numberToolbar
        txtRadius.inputAccessoryView = numberToolbar
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
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction private func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(_ msg: String, completion: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: completion))
        self.present(alert, animated: true)
    }
    
    @IBAction private func saveBtnTapped(_ sender: UIButton) {
        if validateAndSetRegion() {
            if !DataHandler.shared.save(pin) {
                showAlert("Region with same note: \"\(pin.note)\" already exists") { (_) in
                    self.txtViewNote.becomeFirstResponder()
                }
            }
        }
    }
    
    private func validateAndSetRegion() -> Bool {
        guard let pin = pin else {
            showAlert("Location not set", completion: nil)
            return false
        }
        switch validateInputs() {
            case (nil, _):
                showAlert("Invalid note for monitored Region.") { (_) in
                    self.txtViewNote.becomeFirstResponder()
                }
            case (_,nil):
                showAlert("Invalid radius for monitored Region.") { (_) in
                    self.txtRadius.becomeFirstResponder()
                }
        case (let note, let radius):
            pin.setNote(note!)
            pin.setRadius(radius!)
            return true
        }
        return false
    }
    
    private func validateInputs() -> (String?, Double?) {
        return (validateNote(),validateRadius())
    }
    
    private func validateNote() -> String? {
        if let note = txtViewNote.text, !note.isEmpty {
            return note
        }
        return nil
    }
    
    private func validateRadius() -> Double? {
        if let radiusString = txtRadius.text, let radius = Double(radiusString), radius != 0 {
            return radius
        }
        return nil
    }
    
    @objc private func entryOrExitViewSelected(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            removeViewSelection()
            switch tag {
            case 1:
                vwCheckedEntry.backgroundColor = UIColor.systemGreen
                self.monitoredState = .entry
            case 2:
                vwCheckedExit.backgroundColor = UIColor.systemGreen
                self.monitoredState = .exit
            default:
                break
            }
            setEntryOrExitForPin()
        }
    }
    
    private func setEntryOrExitForPin() {
        if pin != nil {
            self.pin.setMonitoredState(monitoredState)
        }
    }
    
    private func removeViewSelection() {
        vwCheckedEntry.backgroundColor = UIColor.lightGray
        vwCheckedExit.backgroundColor = UIColor.lightGray
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        if pin != nil {
            mapView.removeAnnotation(pin)
        }
        pin = CustomPin(coordinate: coordinates, monitoredState: monitoredState)
        mapView.addAnnotation(pin)
    }
}

extension AddViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let radiusString = textField.text, let radius = Double(radiusString) {
            //MARK: update mapview circular region
        }
    }
}

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    private(set) var note: String = ""
    private(set) var monitoredState = MonitoredState.entry
    private(set) var radius: Double = 0
    
    init(coordinate: CLLocationCoordinate2D, monitoredState: MonitoredState) {
        self.coordinate = coordinate
        self.monitoredState = monitoredState
    }
    
    func setMonitoredState(_ state: MonitoredState) {
        self.monitoredState = state
    }
    
    func setNote(_ note: String) {
        self.note = note
    }
    
    func setRadius(_ radius: Double) {
        self.radius = radius
    }
    
}

enum MonitoredState {
    case entry, exit
}

extension String {
    func checkForEmpty() -> Bool {
        if self.trimmingCharacters(in: CharacterSet(charactersIn: " ")).isEmpty {
            return true
        } else {
            return false
        }
    }
}
