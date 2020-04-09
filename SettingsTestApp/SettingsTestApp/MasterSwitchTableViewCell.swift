//
//  MasterSwitchTableViewCell.swift
//  SettingsTestApp
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class MasterSwitchTableViewCell: UITableViewCell {
    
    static let cellId = "MasterSwitchTableViewCell"

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var indicator: UISwitch!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    weak var delegate: MasterSwitchCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        indicator.addTarget(self, action: #selector(switchToggled), for: .touchUpInside)
    }
    
    @objc private func switchToggled() {
        delegate?.setValue(indicator.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(title: String, value: Bool, leftInset: CGFloat) {
        self.lblTitle.text = title
        self.indicator.isOn = value
        leftConstraint.constant = (leftInset == 0 ? 20 : leftInset)
    }

}
