//
//  RandomColorView.swift
//  SettingsTestApp
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RandomColorView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = randomColor()
    }
    
    private func randomColor() -> UIColor {
        return UIColor(red: .random(in: (0...1)), green: .random(in: (0...1)), blue: .random(in: (0...1)), alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
