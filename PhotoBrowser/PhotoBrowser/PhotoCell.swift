//
//  PhotoCell.swift
//  PhotoBrowser
//
//  Created by vinsol on 27/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let cellId = "PhotoCell"
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            imageView.layer.borderWidth = 1
        }
    }
}
