//
//  Enums.swift
//  geoFencingExercise
//
//  Created by vinsol on 17/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation
import UIKit

enum MonitoredState: Int64 {
    case entry, exit, both
    
    static func fromRawValue(_ val: Int64?) -> MonitoredState {
        if let val = val, let state = MonitoredState(rawValue: val) {
            return state
        } else {
            return .both
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .entry:
            return .blue
        case .exit:
            return .red
        case .both:
            return .black
        }
    }
    
    func pinImage() -> UIImage? {
        switch self {
        case .entry:
            return UIImage(named: "bluePin")
        case .exit:
            return UIImage(named: "redPin")
        case .both:
            return UIImage(named: "blackPin")
        }
    }
}
