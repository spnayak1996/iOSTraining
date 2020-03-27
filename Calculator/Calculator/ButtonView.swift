//
//  ButtonView.swift
//  Calculator
//
//  Created by vinsol on 20/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

protocol ButtonViewDelegate: UIViewController {
    func buttonTapped(_ index: Int)
}

class ButtonView: UIView {
    
    @IBOutlet private weak var button: RoundButton!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: ButtonViewDelegate?
    private var index: Int = 0
    
    
    static func loadViewFromNib(owner: UIViewController) -> ButtonView? {
        if let view = Bundle.main.loadNibNamed("ButtonView", owner: owner, options: nil)?.first as? ButtonView {
            return view
        }
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonHeightConstraint.constant = min(bounds.width, bounds.height) - 5
    }
    
    func setUp(index: Int, text: String, bgColor: UIColor, txtColor: UIColor) {
        self.index = index
        button.backgroundColor = bgColor
        button.setTitleColor(txtColor, for: UIControl.State.normal)
        button.setTitle(text, for: UIControl.State.normal)
    }
    
    @IBAction private func buttonTapped(_ sender: RoundButton) {
        delegate?.buttonTapped(index)
    }
    
}
