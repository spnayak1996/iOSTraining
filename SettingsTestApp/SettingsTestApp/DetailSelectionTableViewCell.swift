//
//  DetailSelectionTableViewCell.swift
//  SettingsTestApp
//
//  Created by vinsol on 05/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class DetailSelectionTableViewCell: UITableViewCell {
    
    static let cellId = "DetailSelectionTableViewCell"
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var tick: UIImageView!
    
    private var active: Bool = false {
        didSet {
            if active {
                tick.image = UIImage(named: "tick_48")
            } else {
                tick.image = nil
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(title: String, ticked: Bool) {
        self.lblTitle.text = title
        self.active = ticked
    }
    
    func removeSelection() {
        self.active = false
    }
    
    func setSelection() {
        self.active = true
    }

}
