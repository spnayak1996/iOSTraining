//
//  RoundButton.swift
//  Calculator
//
//  Created by vinsol on 06/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    private var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
