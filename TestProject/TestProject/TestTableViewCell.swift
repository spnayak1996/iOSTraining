//
//  TestTableViewCell.swift
//  TestProject
//
//  Created by vinsol on 19/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    static let cellId = "TestTableViewCell"

    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
