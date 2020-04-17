//
//  CustomPin.swift
//  geoFencingExercise
//
//  Created by vinsol on 17/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    private(set) var note: String = ""
    private(set) var monitoredState = MonitoredState.entry {
        didSet {
            setImage()
        }
    }
    private(set) var radius: Double = 0
    private(set) var image: UIImage?
    
    private init(coordinate: CLLocationCoordinate2D, monitoredState: MonitoredState, radius: Double, note: String) {
        self.coordinate = coordinate
        self.monitoredState = monitoredState
        self.radius = radius
        self.note = note
    }
    
    static func createPin(coordinate: CLLocationCoordinate2D, monitoredState: MonitoredState, radius: Double, note: String) -> CustomPin {
        let pin = CustomPin(coordinate: coordinate, monitoredState: monitoredState, radius: radius, note: note)
        pin.setImage()
        return pin
    }
    
    func setImage() {
        image = monitoredState.pinImage()
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
