//
//  TestView.swift
//  TestProject
//
//  Created by vinsol on 25/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class TestView: UIView {
    
    static let nibId = "TestView"

    @IBOutlet weak var lblText: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func setUp(text: String) {
        self.lblText.text = text
    }

}
