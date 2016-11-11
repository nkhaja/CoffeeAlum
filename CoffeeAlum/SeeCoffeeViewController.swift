//
//  SeeCoffeeViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-09.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit

class SeeCoffeeViewController: UIViewController {
    
    var userBeingVisited: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
}
