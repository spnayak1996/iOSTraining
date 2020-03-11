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
    @IBOutlet private(set) weak var lblBold: UILabel! {
        didSet {
            lblBold.alpha = 0
        }
    }
    @IBOutlet private(set) weak var lblRegular: UILabel! {
        didSet {
            lblRegular.alpha = 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
