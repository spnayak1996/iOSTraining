//
//  DrawerViewController.swift
//  DrawerAnimation
//
//  Created by vinsol on 09/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    
    static let controllerId = "DrawerViewController"
    
    @IBOutlet private(set) weak var handleView: UIView!
    @IBOutlet private(set) weak var lblBlue: UILabel! {
        didSet {
            lblBlue.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            lblBlue.textColor = .systemBlue
        }
    }
    @IBOutlet private(set) weak var lblBlack: UILabel! {
        didSet {
            lblBlack.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            lblBlack.textColor = .black
            lblBlack.alpha = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
