//
//  ProfileViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring
import Firebase

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
    var userRef: FIRDataSnapshot?
    var interests: [String] = []
    var education: [Education] = []
    var employment: [Employer] = []
    var data = NSArray()


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController{
            self.user = tbc.thisUser
        }
        if let user = self.user{
            nameLabel.text = user.name
            locationLabel.text = user.location
            careerLabel.text = user.employer[0].name
            profileImage.image = Helper.dataStringToImage(dataString: user.portrait)
            employment = user.employer
            education = user.education
            interests = user.interests
            tableView.reloadData()
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
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            return employment.count
        case 1:
            return interests.count
        case 2:
            return education.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        
        if segmentedControl.selectedSegmentIndex == 0  {
            cell.itemLabel.text = employment[indexPath.row].name
        }
        
        else if segmentedControl.selectedSegmentIndex == 1{
            cell.itemLabel.text = interests[indexPath.row]
            
            
        }
        
        else if segmentedControl.selectedSegmentIndex == 2 {
            // TODO: Change into .name after Field of Study is implemented.
            cell.itemLabel.text = education[indexPath.row].school
            
        }
        return cell
    }
    
}





