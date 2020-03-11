//
//  RoundView.swift
//  GeoFencing
//
//  Created by vinsol on 09/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class RoundView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.bounds.width/2
    }

}
