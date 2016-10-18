//
//  ProfileViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: DesignableImageView!
    @IBOutlet weak var nameLabel: DesignableLabel!
    @IBOutlet weak var careerLabel: DesignableLabel!
    @IBOutlet weak var locationLabel: DesignableLabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

    @IBAction func CoffeeButton(_ sender: AnyObject) {
    }
    
    func changeTableContent(){
        //use this function to change contents with segment control
        
        if segmentedControl.selectedSegmentIndex == 0 {
            tableView.reloadData()
        }
        
        else if segmentedControl.selectedSegmentIndex == 1 {
            tableView.reloadData()

        }
        
        else {
            tableView.reloadData()

        }
    }

 

}

extension ProfileViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        return cell
    }
    
}
