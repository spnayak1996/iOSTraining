//
//  MasterNavigableTableViewCell.swift
//  SettingsTestApp
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class MasterNavigableTableViewCell: UITableViewCell {
    
    static let cellId = "MasterNavigableTableViewCell"

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(title: Enums.Detail, value: String) {
        self.lblTitle.text = title.title()
        switch title {
        case .wifi,.bluetooth,.carrier,.mobileData:
            lblValue.isHidden = false
            self.lblValue.text = value
        default:
            lblValue.isHidden = true
        }
    }

}
