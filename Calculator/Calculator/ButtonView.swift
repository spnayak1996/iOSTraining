//
//  ButtonView.swift
//  Calculator
//
//  Created by vinsol on 20/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

@objc protocol ButtonViewDelegate {
    func buttonTapped(_ tag: Int)
}

class ButtonView: UIView {
    
    @IBOutlet private weak var button: RoundButton!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    var bgColor = UIColor.black {
        didSet {
            button?.backgroundColor = bgColor
        }
    }
    var textColor = UIColor.white {
        didSet {
            button?.setTitleColor(textColor, for: UIControl.State.normal)
        }
    }
    var text: String = "" {
        didSet {
            button?.setTitle(text, for: UIControl.State.normal)
        }
    }
    
    weak var delegate: ButtonViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonHeightConstraint.constant = min(bounds.width, bounds.height) - 15
        button.backgroundColor = bgColor
        button.setTitleColor(textColor, for: UIControl.State.normal)
        button.setTitle(text, for: UIControl.State.normal)
    }
    
    @IBAction private func buttonTapped(_ sender: RoundButton) {
        delegate?.buttonTapped(tag)
    }
    
}

@IBDesignable
class ButtonXIBView: UIView {
    var view: ButtonView!
    static let nibName = "ButtonView"
    
    @IBInspectable private var bgColor: UIColor = .black {
        didSet {
            view?.bgColor = bgColor
        }
    }
    @IBInspectable private var textColor: UIColor = .white {
        didSet {
            view?.textColor = textColor
        }
    }
    @IBInspectable private var text: String = "" {
        didSet {
            view?.text = text
        }
    }
    @IBOutlet weak var delegate: ButtonViewDelegate? {
        didSet {
            view?.delegate = delegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        self.backgroundColor = .clear
    }

    func loadViewFromNib() -> ButtonView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! ButtonView
        view.bgColor = bgColor
        view.textColor = textColor
        view.text = text
        view.delegate = delegate
        view.tag = self.tag
        return view
    }
}
