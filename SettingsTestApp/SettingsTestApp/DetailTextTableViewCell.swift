//
//  DetailTextTableViewCell.swift
//  SettingsTestApp
//
//  Created by vinsol on 05/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class DetailTextTableViewCell: UITableViewCell {
    
    static let cellId = "DetailTextTableViewCell"
    
    @IBOutlet private weak var lblText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(text: String) {
        self.lblText.text = text
    }

}
