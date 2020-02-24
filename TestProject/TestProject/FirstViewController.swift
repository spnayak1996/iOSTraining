//
//  FirstViewController.swift
//  TestProject
//
//  Created by vinsol on 18/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    static let controllerId = "FirstViewController"
    
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBAction func btnClicked() {
        let vc = self.storyboard?.instantiateViewController(identifier: TestTableViewController.controllerId) as! TestTableViewController
//        vc?.modalPresentationStyle = UIModalPresentationStyle.popover
//        self.showDetailViewController(vc!, sender: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonConstraint.constant = view.bounds.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.buttonConstraint.constant = 40
            self.view.layoutIfNeeded()
            print("animated")
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
