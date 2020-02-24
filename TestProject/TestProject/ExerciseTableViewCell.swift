//
//  ExerciseTableViewCell.swift
//  TestProject
//
//  Created by vinsol on 24/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    static let cellId = "ExerciseTableViewCell"
    
    private let image1 = "Image1"
    private let image2 = "Image4"

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.accessoryType = selected ? .checkmark : .none
    }
    
    func setData(index: Int, data: String) {
        bgImage.image = UIImage(named: (index % 2 == 0 ? image1 : image2))
        lblText.text = data
    }

}
