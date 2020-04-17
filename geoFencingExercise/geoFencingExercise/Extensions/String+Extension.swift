//
//  String+Extension.swift
//  geoFencingExercise
//
//  Created by vinsol on 17/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation

extension String {
    func checkForEmpty() -> Bool {
        if self.trimmingCharacters(in: CharacterSet(charactersIn: " ")).isEmpty {
            return true
        } else {
            return false
        }
    }
}
