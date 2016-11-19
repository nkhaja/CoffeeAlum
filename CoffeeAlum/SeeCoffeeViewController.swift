//
//  SeeCoffeeViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-09.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class SeeCoffeeViewController: UIViewController {
    
    
    //Needs a map for the location
    @IBOutlet weak var whoLabel: DesignableLabel!
    @IBOutlet weak var whenLabel: DesignableLabel!
    @IBOutlet weak var whereLabel: DesignableLabel!
    
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var confirmButton: DesignableButton!
    @IBOutlet weak var rescheduleButton: DesignableButton!
    
    var userBeingVisited: User?
    var thisCoffee: Coffee?
    var isInvited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.isInvited{
            confirmButton.isHidden = true
            ignoreButton.isHidden = true
            rescheduleButton.isHidden = true
        }
        
        else if thisCoffee!.accepted{
            confirmButton.setTitle("Cancel", for: UIControlState.normal)
            confirmButton.isHidden = true
            ignoreButton.isHidden = true
            rescheduleButton.isHidden = false
        }
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profile" {
            if let profileViewController = segue.destination as? ProfileViewController{
                profileViewController.profileUser = userBeingVisited
            }
        }
    }

    

    @IBAction func profileButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func confirmButton(_ sender: AnyObject) {
        
    }
    
    

    
}
