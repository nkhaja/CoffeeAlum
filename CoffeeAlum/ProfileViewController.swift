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

    //Database References
    
    //MARK: Outlets
    @IBOutlet weak var profileImage: DesignableImageView!
    @IBOutlet weak var nameLabel: DesignableLabel!
    @IBOutlet weak var careerLabel: DesignableLabel!
    @IBOutlet weak var locationLabel: DesignableLabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // Local Variables
    var user: User?
    var interests: [String] = []
    var academic: [String] = []
    var experience: [Employer] = []
    var data = NSArray()


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = self.user{
            nameLabel.text = user.name
            locationLabel.text = user.location
            
            if let employer = user.employer {
                careerLabel.text = employer.name
            }
            profileImage.image = Helper.dataStringToImage(dataString: user.portrait)
        }


    }



    @IBAction func CoffeeButton(_ sender: AnyObject) {
    }
    

    @IBAction func segmentButton(_ sender: AnyObject) {
        tableView.reloadData()
    }
    
    
    

}

extension ProfileViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // We are assigning the insterests to be stored in the data array.
            cell.itemLabel.text = experience[indexPath.row].name
            tableView.reloadData()
        }
        
        else if segmentedControl.selectedSegmentIndex == 1 {
                cell.itemLabel.text = interests[indexPath.row]
                tableView.reloadData()
        }
        
        else {
            // TODO: Change into .name after Field of Study is implemented.
            cell.itemLabel.text = academic[indexPath.row]
            tableView.reloadData()
        }

        return cell
    }
    
}





