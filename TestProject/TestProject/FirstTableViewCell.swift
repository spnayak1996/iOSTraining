//
//  FirstTableViewCell.swift
//  TestProject
//
//  Created by vinsol on 26/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

protocol FirstTableViewCellDelegate: AnyObject {
    func deleteCell(cell: FirstTableViewCell)
}

class FirstTableViewCell: UITableViewCell {
    
    static let cellId = "FirstTableViewCell"
    
    weak var delegate: FirstTableViewCellDelegate?

    @IBOutlet weak var lblDetail: UILabel!
    @IBAction func deleteTapped() {
        delegate?.deleteCell(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(data: Int) {
        self.lblDetail.text = "\(data)"
    }

}
