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
    @IBOutlet weak var arrow: UILabel!
    private(set) var detail: Enums.Detail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            lblValue.textColor = UIColor.white
            arrow.textColor = UIColor.white
        } else {
            contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblValue.textColor = UIColor.lightGray
            arrow.textColor = UIColor.lightGray
        }
    }
    
    func setUpCell(title: Enums.Detail, value: String) {
        self.detail = title
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
