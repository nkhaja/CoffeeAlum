//
//  PersonalViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-10.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring
import Firebase

class PersonalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var thisUser:User?
    var userRef: FIRDatabaseReference?
    var tbc: CustomTabBarController?
    var interests: [String] = []
    var academic: [String] = []
    var experience: [Employer] = []
    
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: DesignableLabel!
    @IBOutlet weak var imageView: DesignableImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //ImagePicker
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if let tbc = self.tabBarController as? CustomTabBarController{
            self.thisUser = tbc.thisUser
            self.userRef = tbc.userRef
        }
    }


    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            thisUser!.portrait = Helper.imageToDataString(image: pickedImage)
            
            userRef?.setValue(thisUser?.toAnyObject())
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func changePictureButton(_ sender: DesignableButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion:nil)
    }


    
    
    @IBAction func addItemButton(_ sender: DesignableButton) {
        
    }

}


extension PersonalViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return experience.count
        }
            
        else if segmentedControl.selectedSegmentIndex == 1 {
           return interests.count
        }
            
        else {
            // TODO: Change into .name after Field of Study is implemented.
            return academic.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalCell") as! PersonalTableViewCell
        
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
