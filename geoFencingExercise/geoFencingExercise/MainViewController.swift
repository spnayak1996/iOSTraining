//
//  MainViewController.swift
//  GeoFencing
//
//  Created by vinsol on 09/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
    
    static let controllerId = "MainViewController"
    
    private let locationManager = CLLocationManager()

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.layer.borderWidth = 0.5
            segmentedControl.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            segmentedControl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
            
        }
    }
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    private var monitoredState: MonitoredState? {
        didSet {
           updateRegionOverlays(state: monitoredState)
        }
    }
    private var monitoredRegions = [MonitoredRegions]()
    private var overlayRegions = [MonitoredRegions]()
    private var currentlyMonitoredRegions = [CLRegion]()
    private var pins = [CustomPin]()
    static let meters: CLLocationDistance = 30000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLocationManager()
        checkLocationServices()
        setUpBothMonitorAndOverlay()
    }
    
    private func updateRegionOverlays(state: MonitoredState?) {
        overlayRegions = DataHandler.shared.getAllMonitoredRegions(state: state)
        addOverlays()
    }
    
    private func setAllMonitoredRegions() {
        monitoredRegions = DataHandler.shared.getAllMonitoredRegions(state: nil)
        monitorRegions()
    }
    
    private func setUpBothMonitorAndOverlay() {
        setAllMonitoredRegions()
        updateRegionOverlays(state: nil)
        self.mapView.showAnnotations(pins, animated: true)
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorisation()
        } else {
            showAlert(message: "You need to switch on location services in your phone settings.")
        }
    }
    
    private func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlert(message: "Your location services are restricted for our app due to parental controls or some other reason.")
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            showCurrentLocation(UIButton())
        @unknown default:
            break
        }
    }
    
    private func removeMonitoredRegions() {
        for region in currentlyMonitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        currentlyMonitoredRegions = [CLRegion]()
    }
    
    private func removeOverlays() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(pins)
        pins = [CustomPin]()
    }
    
    private func monitorRegions() {
        removeMonitoredRegions()
        for moniteredRegion in monitoredRegions {
            monitorARegion(moniteredRegion)
        }
    }
    
    private func addOverlays() {
        removeOverlays()
        for region in overlayRegions {
            addOverlay(region)
        }
    }
    
    private func monitorARegion(_ region: MonitoredRegions) {
        let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude), radius: region.radius, identifier: region.note!)
        currentlyMonitoredRegions.append(circularRegion)
        locationManager.startMonitoring(for: circularRegion)
    }
    
    private func addOverlay(_ region: MonitoredRegions) {
        let pin = CustomPin.createPin(coordinate: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude), monitoredState: region.entry ? .entry : .exit, radius: region.radius, note: region.note!)
        mapView.addAnnotation(pin)
        pins.append(pin)
        
        let circle = MyMKCircle(center: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude), radius: region.radius, state: (region.entry ? .entry : .exit))
        mapView.addOverlay(circle)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction private func addLocation(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: AddViewController.controllerId) as! AddViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func showCurrentLocation(_ sender: UIButton) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: Self.meters, longitudinalMeters: Self.meters)
            mapView.showsUserLocation = true
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func filterEntryOrExit(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.monitoredState = nil
        case 1:
            self.monitoredState = .entry
        case 2:
            self.monitoredState = .exit
        default:
            break
        }
    }
}

extension MainViewController: MKMapViewDelegate {
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
        let view = MKAnnotationView()
        if let pin = annotation as? CustomPin {
            view.image = pin.image
            view.centerOffset = CGPoint(x: 0, y: -20)
        }
        return view
    }
}

extension MainViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            return
//        }
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: Self.meters, longitudinalMeters: Self.meters)
//        mapView.setRegion(region, animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorisation()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let index = currentlyMonitoredRegions.firstIndex(of: region) {
            let monitoredRegion = monitoredRegions[index]
            if monitoredRegion.entry {
                showAlert(message: "entered \(monitoredRegion.note!)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let index = currentlyMonitoredRegions.firstIndex(of: region) {
            let monitoredRegion = monitoredRegions[index]
            if !monitoredRegion.entry {
                showAlert(message: "exited \(monitoredRegion.note!)")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pin = view.annotation as? CustomPin, let index = pins.firstIndex(of: pin) {
            let actionSheet = UIAlertController(title: "Options", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] (_) in
                DataHandler.shared.delete(self?.monitoredRegions[index])
                self?.setAllMonitoredRegions()
                self?.updateRegionOverlays(state: self?.monitoredState)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(actionSheet, animated: true)
        }
    }
}

extension MainViewController: AddViewControllerDelegate {
    func updateView() {
        setAllMonitoredRegions()
        updateRegionOverlays(state: self.monitoredState)
        self.mapView.showAnnotations(pins, animated: true)
    }
}

class MyMKCircle: MKCircle {
    private var state: MonitoredState!
    private(set) var color = UIColor.blue
    
    convenience init(center: CLLocationCoordinate2D, radius: CLLocationDistance, state: MonitoredState) {
        self.init(center: center, radius: radius)
        self.state = state
        self.color = (state == .entry ? .blue : .red)
    }
}

