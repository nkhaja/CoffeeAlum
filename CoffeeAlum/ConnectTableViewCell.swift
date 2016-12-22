//
//  ConnectTableViewCell.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class ConnectTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: DesignableLabel!
    @IBOutlet weak var locationLabel: DesignableLabel!
    @IBOutlet weak var schoolLabel: DesignableLabel!
    @IBOutlet weak var employmentLabel: DesignableLabel!
    @IBOutlet weak var profileImage: DesignableImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
