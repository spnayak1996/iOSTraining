//
//  Double+Extension.swift
//  Calculator
//
//  Created by vinsol on 17/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation

extension Double {
    func withCommas() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        return formatter.string(from: NSNumber(value: self))
    }
    
    func toEntryStringFormat() -> String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter.string(from: NSNumber(value: self))
    }
    
    func extractInt() -> Int {
        return Int(self)
    }
}
