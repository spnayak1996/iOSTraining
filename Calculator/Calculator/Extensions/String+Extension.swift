//
//  String+Extension.swift
//  Calculator
//
//  Created by vinsol on 17/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation

extension String {
    func containsConsecutiveEndZerosAfterDecimal() -> (Int,Bool)? {
        if !self.contains(".") {
            return nil
        }
        var string = self
        var count = 0
        while true {
            let last = string.removeLast()
            if last == "0" {
                count += 1
            } else if last == "." {
                return (count == 0 ? nil : (count,true))
            } else {
                return (count == 0 ? nil : (count,false))
            }
        }
    }
    
    func firstIndex(of element: Character) -> Int? {
        var count = 0
        for i in self {
            if i == element {
                return count
            }
             count += 1
        }
        return nil
    }
}
