//
//  MyCollectionViewCell.swift
//  GridProject
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "MyCollectionViewCell"
    
    @IBOutlet private weak var lblTitle: UILabel!
    private var title: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.contentView.layer.borderWidth = 0.5
    }
    
    func setUp(_ title: String) {
        lblTitle.text = title
    }
    
}
