//
//  CustomTabBarController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-18.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Firebase


class CustomTabBarController: UITabBarController {
    var thisUser:User?
    var thisUserRef: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If being invited, create notification for each unseen Coffee
        if let thisUser = self.thisUser{
            var unseenInvitations = 0
            for c in thisUser.coffees{
                if !c.viewed && thisUser.uid == c.toId{
                    unseenInvitations += 1
                }
            }
            self.tabBar.items![2].badgeValue = String(unseenInvitations)
        }
        

    }


}
