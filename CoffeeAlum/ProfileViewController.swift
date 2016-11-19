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
    @IBOutlet weak var coffeeButtonLabel: UIButton!
    
    // Local Variables
    var profileUser: User? // populated by segue; User featured in this Profile; below are their attributes
    var thisProfileUserRef: FIRDataSnapshot?
    var thisUser: User? // the active user for this account
    var interests: [Interest] = []
    var education: [Education] = []
    var employment: [Employer] = []
    var data = NSArray()
    
    // ViewController for Sending emails
    var mailViewController = MailViewController()


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if thisUser?.uid == profileUser?.uid{
            coffeeButtonLabel.isHidden = true
        }

        if let tbc = self.tabBarController as? CustomTabBarController{
            self.thisUser = tbc.thisUser
        }
        
        if let profileUser = self.profileUser{
            nameLabel.text = profileUser.name
            locationLabel.text = profileUser.location
            careerLabel.text = profileUser.employer[0].name
            profileImage.image = Helper.dataStringToImage(dataString: profileUser.portrait)
            employment = profileUser.employer
            education = profileUser.education
            interests = profileUser.interests
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "email"{
            if let mailViewController = segue.destination as? MailViewController{
                mailViewController.thisUser = self.thisUser
                mailViewController.recipientUser = self.profileUser
            }
        }
    }



    @IBAction func CoffeeButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "email", sender: self)
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
            cell.itemDescription.text = employment[indexPath.row].position
        }
        
        else if segmentedControl.selectedSegmentIndex == 1{
            cell.itemLabel.text = interests[indexPath.row].name
            
            
        }
        
        else if segmentedControl.selectedSegmentIndex == 2 {
            // TODO: Change into .name after Field of Study is implemented.
            cell.itemLabel.text = education[indexPath.row].school
            cell.itemDescription.text = education[indexPath.row].major

        }
        return cell
    }
    
}




