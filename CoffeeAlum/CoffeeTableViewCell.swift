//
//  CoffeeTableViewCell.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-08.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class CoffeeTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var whoLabel: DesignableLabel!
    @IBOutlet weak var whenLabel: DesignableLabel!
    @IBOutlet weak var whereLabel: DesignableLabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
