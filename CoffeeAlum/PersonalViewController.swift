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



class PersonalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    var thisUser:User?
    
    var thisUserRef: FIRDatabaseReference?
    var employerRef: FIRDatabaseReference?
    var educationRef: FIRDatabaseReference?
    
    var tbc: CustomTabBarController?
    var interests: [String] = []
    var academic: [String] = []
    var employment: [Employer] = []
    
    var canEdit:Bool = false
    var changesMade = false
    var saveRequested: Bool = false
    var savedChanges:Bool = true
    
    
    // MARK: Outlets - Labels
    
    @IBOutlet weak var nameLabel: DesignableLabel!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Outlets - TextFields
    
    @IBOutlet weak var nameTextField: DesignableTextField!
    
    //ImagePicker
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        if let tbc = self.tabBarController as? CustomTabBarController{
            self.thisUser = tbc.thisUser
            self.thisUserRef = tbc.thisUserRef
        }
        
        
        nameTextField.delegate = self
        nameTextField.isHidden = true
        nameLabel.text = thisUser?.name
        nameLabel.isUserInteractionEnabled = true
        let aSelector : Selector = "labelTapped"
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        nameLabel.addGestureRecognizer(tapGesture)
        
    }
    
    func labelTapped(){
        nameLabel.isHidden = true
        nameTextField.isHidden = false
        nameTextField.text = nameLabel.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        nameTextField.isHidden = true
        nameLabel.isHidden = false
        nameLabel.text = nameTextField.text
        thisUser!.name = nameLabel.text!
        return true
    }


    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
            thisUser!.portrait = Helper.imageToDataString(image: pickedImage)
            self.profileImageView.image = pickedImage
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

    
    func allowEdits() {
        canEdit = true
        changesMade = true
        savedChanges = false
        tableView.reloadData()
        
    }
    
    func saveEdits(){
        canEdit = false
        changesMade = false
        saveRequested = true
        savedChanges = true
        tableView.reloadData()
        
        
        for e in thisUser!.employer{
            e.ref!.setValue(e.toAnyObject())
        }
        
        for e in thisUser!.education{
            e.ref!.setValue(e.toAnyObject())
        }

        educationRef?.setValue(thisUser?.education)
        
        
    }

    @IBAction func saveEditsButton(_ sender: AnyObject) {
        if canEdit == false{
            allowEdits()
        }
        else{
            saveEdits()
        }
    }
    
    
    @IBAction func addItemButton(_ sender: DesignableButton) {
    }
    
    @IBAction func segmentButton(_ sender: AnyObject) {
        tableView.reloadData()
    }
    

}



extension PersonalViewController: UITableViewDataSource, CellDataDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return self.thisUser!.employer.count
        }
            
        else if segmentedControl.selectedSegmentIndex == 1 {
           return self.thisUser!.interests.count
        }
            
        else {
            // TODO: Change into .name after Field of Study is implemented.
            return self.thisUser!.education.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalCell") as! PersonalTableViewCell
        
        //cell.delegate = self
        cell.canEdit = self.canEdit
        cell.savedChanges = self.savedChanges
        cell.saveRequested = self.saveRequested
        cell.thisRow = indexPath.row
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // We are assigning the insterests to be stored in the data array.
            cell.itemLabel.text = self.thisUser!.employer[indexPath.row].name
            cell.source = "experience"
        }
            
        else if segmentedControl.selectedSegmentIndex == 1 {
            cell.itemLabel.text = self.thisUser!.interests[indexPath.row]
            cell.source = "interests"
        }
            
        else {
            // TODO: Change into .name after Field of Study is implemented.
            cell.itemLabel.text = self.thisUser!.education[indexPath.row].school
            cell.source = "academic"
        }
        
        self.saveRequested = false
        return cell
    }
    
    
    
    
    
    func updateEdits(index:Int, source:String, data:[String]){
        
    }
    
    func getUser() -> User {
        return self.thisUser!
    }
    
    func changesMade(changed: Bool){
        changesMade = changed
    }


    
}




