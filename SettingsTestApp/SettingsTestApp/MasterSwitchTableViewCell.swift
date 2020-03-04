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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(title: String, value: Bool) {
        self.lblTitle.text = title
        self.indicator.isOn = value
    }

}
