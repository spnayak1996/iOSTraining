//
//  DetailSwitchTableViewCell.swift
//  SettingsTestApp
//
//  Created by vinsol on 05/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class DetailSwitchTableViewCell: UITableViewCell {
    
    static let cellId = "DetailSwitchTableViewCell"
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var indicator: UISwitch!
    
    weak var delegate: DetailViewCellDelegate?
    
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
    
    func setUp(title: String, on: Bool) {
        self.lblTitle.text = title
        self.indicator.isOn = on
    }

}
