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
    private var monitoredRegions: [MonitoredRegions]!
    private var currentlyMonitoredRegions = [CLRegion]()
    private var pins = [CustomPin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLocationManager()
        checkLocationServices()
        getMonitoredRegions()
    }
    
    private func getMonitoredRegions() {
        monitoredRegions = DataHandler.shared.getAllMonitoredRegions()
        monitorRegions()
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
//            setUpLocationManager()
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
            setUpMap()
            showCurrentLocation(UIButton())
        @unknown default:
            break
        }
    }
    
    private func setUpMap() {
        mapView.showsUserLocation = true
    }
    
    private func stopMonitoringAllRegions() {
        mapView.removeOverlays(mapView.overlays)
        for region in currentlyMonitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        mapView.removeAnnotations(pins)
        pins = [CustomPin]()
        currentlyMonitoredRegions = [CLRegion]()
    }
    
    private func monitorRegions() {
        stopMonitoringAllRegions()
        for moniteredRegion in monitoredRegions {
            monitorARegion(moniteredRegion)
        }
    }
    
    private func monitorARegion(_ region: MonitoredRegions) {
        let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude), radius: region.radius, identifier: region.note!)
        currentlyMonitoredRegions.append(circularRegion)
        locationManager.startMonitoring(for: circularRegion)
        
        let pin = CustomPin(coordinate: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude), monitoredState: region.entry ? .entry : .exit, radius: region.radius, note: region.note!)
        mapView.addAnnotation(pin)
        pins.append(pin)
        
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: region.latitude, longitude: region.longitude), radius: region.radius)
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
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {
            return MKOverlayRenderer()
        }
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.fillColor = .blue
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    
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
            actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
                DataHandler.shared.delete(self.monitoredRegions[index])
                self.getMonitoredRegions()
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(actionSheet, animated: true)
        }
    }
}

extension MainViewController: AddViewControllerDelegate {
    func updateView() {
        //MARK: to be added
        getMonitoredRegions()
    }
}

