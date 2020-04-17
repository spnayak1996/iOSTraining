//
//  MyMKCircle.swift
//  geoFencingExercise
//
//  Created by vinsol on 17/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation
import MapKit

class MyMKCircle: MKCircle {
    private var state: MonitoredState!
    private(set) var color = UIColor.blue
    
    convenience init(center: CLLocationCoordinate2D, radius: CLLocationDistance, state: MonitoredState) {
        self.init(center: center, radius: radius)
        self.state = state
        self.color = state.color()
    }
}
