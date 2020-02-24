//
//  DetailViewController.swift
//  TestProject
//
//  Created by vinsol on 20/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    static let controllerId = "DetailViewController"
    
    private var value: String = "0"

    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lblDetail.text = value
        configureGestures()
    }
    
    private func configureGestures() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("deinitialized \(Self.controllerId)")
    }
    
    @IBAction func backHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setValue(_ val: String) {
        self.value = val
    }
    
    @IBAction func bounce(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 9, options: .curveEaseInOut, animations: {
            self.buttonHeightConstraint.constant += 60
            self.view.layoutIfNeeded()
        }) { (success) in
            if success {
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 9, options: .curveLinear, animations: {
                    self.buttonHeightConstraint.constant -= 60
                    self.view.layoutIfNeeded()
                }) { (_) in
                    sender.isUserInteractionEnabled = true
                }
            }
        }
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
