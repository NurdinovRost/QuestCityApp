//
//  MenuTableViewCell.swift
//  Project
//
//  Created by Ростислав Нурдинов on 07.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var btnNavigation: UIButton!

    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}


