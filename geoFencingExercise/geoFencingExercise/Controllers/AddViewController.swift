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

protocol AddViewControllerDelegate: UIViewController {
    func updateView()
}

class AddViewController: UIViewController {
    
    static let controllerId = "AddViewController"

    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
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
    @IBOutlet private weak var entryButton: UIButton! {
        didSet {
            entryButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal)
            entryButton.setImage(UIImage(systemName : "circle.fill"), for: UIControl.State.selected)
            entryButton.isSelected = true
            entryButton.tag = 1
        }
    }
    @IBOutlet private weak var exitButton: UIButton! {
        didSet {
            exitButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal)
            exitButton.setImage(UIImage(systemName : "circle.fill"), for: UIControl.State.selected)
            exitButton.isSelected = false
            exitButton.tag = 2
        }
    }
    @IBOutlet private weak var topNavigationView: UIView!
    @IBOutlet private weak var bottomDetailView: UIView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    private var monitoredState = MonitoredState.entry {
        didSet {
            updatePinColorForState()
            updateHighlightedRegion()
        }
    }
    private let locationManager = CLLocationManager()
    weak var delegate: AddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        addToolbar()
        setUpLocationManager()
        setTapGesture()
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        bottomDetailView.addGestureRecognizer(tapGesture2)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        topNavigationView.addGestureRecognizer(tapGesture3)
    }
    
    @objc private func dismissKeyboardOnTap() {
        self.view.endEditing(true)
    }
    
    private func addToolbar() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithKeyboard))]
        numberToolbar.sizeToFit()
        txtViewNote.inputAccessoryView = numberToolbar
        txtRadius.inputAccessoryView = numberToolbar
    }
    
    @objc private func doneWithKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                self.bottomConstraint.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction private func currentLocation(_ sender: UIButton) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: MainViewController.meters, longitudinalMeters: MainViewController.meters)
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
            } else {
                delegate?.updateView()
                closeBtnTapped(UIButton())
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
        if let note = txtViewNote.text, !note.checkForEmpty() {
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
    
    @IBAction private func entryOrExitViewSelected(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            entryViewTapped()
        case 2:
            exitViewTapped()
        default:
            break
        }
        setEntryOrExitForPin()
    }
    
    private func entryViewTapped() {
        if self.monitoredState == .both {
            entryButton.isSelected = false
            self.monitoredState = .exit
        } else if self.monitoredState == .exit {
            entryButton.isSelected = true
            self.monitoredState = .both
        }
    }
    
    private func exitViewTapped() {
        if self.monitoredState == .both {
            exitButton.isSelected = false
            self.monitoredState = .entry
        } else if self.monitoredState == .entry {
            exitButton.isSelected = true
            self.monitoredState = .both
        }
    }
    
    private func setEntryOrExitForPin() {
        if pin != nil {
            self.pin.setMonitoredState(monitoredState)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard sender.numberOfTouches == 1 else {
            return
        }
        let location = sender.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        if pin != nil {
            mapView.removeAnnotation(pin)
        }
        pin = CustomPin.createPin(coordinate: coordinates, monitoredState: monitoredState, radius: validateRadius() ?? 0, note: validateNote() ?? "default")
        mapView.addAnnotation(pin)
        updateHighlightedRegion()
    }
    
    private func updatePinColorForState() {
        if pin != nil {
            let currentPin = pin
            mapView.removeAnnotation(pin)
            
            currentPin?.setMonitoredState(monitoredState)
            pin = currentPin
            mapView.addAnnotation(pin)
        }
    }
    
    private func updateHighlightedRegion() {
        if pin != nil {
            let circle = MyMKCircle(center: pin.coordinate, radius: pin.radius, state: monitoredState)
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(circle)
        }
    }
}

extension AddViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let radiusString = textField.text {
            pin?.setRadius(Double(radiusString) ?? 0)
            updateHighlightedRegion()
        }
    }
}

extension AddViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MyMKCircle else {
            return MKOverlayRenderer()
        }
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.fillColor = circleOverlay.color
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let pin = annotation as? CustomPin {
            let view = MKAnnotationView()
            view.image = pin.image
            view.centerOffset = CGPoint(x: 0, y: -(view.frame.height/2))
            return view
        }
        return nil
    }
}

extension AddViewController: CLLocationManagerDelegate {
    
}
