//
//  ProfileTableViewCell.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-10.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemLabel: DesignableLabel!
    @IBOutlet weak var itemDescription: DesignableLabel!
    @IBOutlet weak var itemImage: DesignableImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
