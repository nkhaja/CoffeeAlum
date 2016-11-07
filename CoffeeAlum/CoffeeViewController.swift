//
//  CoffeeViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Firebase
class CoffeeViewController: UIViewController {
    
    var thisUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tbc = self.tabBarController as? CustomTabBarController {
            self.thisUser = tbc.thisUser
        }
        
        
        

    }


    


}
