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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLocationManager()
        checkLocationServices()
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
            centerOnUserLocation()
        @unknown default:
            break
        }
    }
    
    private func setUpMap() {
        mapView.showsUserLocation = true
    }
    
    @IBAction private func centerOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func monitorARegion() {
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    }

    @IBAction private func addLocation(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: AddViewController.controllerId) as! AddViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func showCurrentLocation(_ sender: UIButton) {
    }
}

extension MainViewController: MKMapViewDelegate {
    
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
}

