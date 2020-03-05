//
//  DetailNavigableTableViewCell.swift
//  SettingsTestApp
//
//  Created by vinsol on 05/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class DetailNavigableTableViewCell: UITableViewCell {
    
    static let cellId = "DetailNavigableTableViewCell"
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(title: String, detail: String) {
        self.lblTitle.text = title
        self.lblDetail.text = detail
    }

}
