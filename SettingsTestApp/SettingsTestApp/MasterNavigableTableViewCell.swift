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
    @IBOutlet private weak var lblValue: UILabel!
    @IBOutlet private weak var arrow: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    private(set) var detail: Enums.Detail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = #colorLiteral(red: 0, green: 0.6451065379, blue: 1, alpha: 1)
            lblTitle.textColor = UIColor.white
            lblValue.textColor = UIColor.white
            arrow.textColor = UIColor.white
        } else {
            contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lblTitle.textColor = UIColor.black
            lblValue.textColor = UIColor.lightGray
            arrow.textColor = UIColor.lightGray
        }
    }
    
    func setUpCell(title: Enums.Detail, value: String, last: Bool, leftInset: CGFloat) {
        self.detail = title
        self.lblTitle.text = title.title()
        switch title {
        case .wifi,.bluetooth,.carrier,.mobileData:
            lblValue.isHidden = false
            self.lblValue.text = value
        default:
            lblValue.isHidden = true
        }
        if last {
            separatorView.isHidden = true
        } else {
            separatorView.isHidden = false
        }
        leftConstraint.constant = (leftInset == 0 ? 20 : leftInset)
    }

}
