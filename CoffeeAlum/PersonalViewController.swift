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
    var newName:String?
    
    
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
        if(canEdit){
            nameLabel.isHidden = true
            nameTextField.isHidden = false
            nameTextField.text = nameLabel.text
            changesMade = true
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        nameTextField.isHidden = true
        nameLabel.text = nameTextField.text
        nameLabel.isHidden = false
        newName = nameLabel.text
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
        savedChanges = false
        tableView.reloadData()
        
    }
    
    func saveEdits(){
        canEdit = false
        changesMade = false
        saveRequested = true
        savedChanges = true
        
        thisUser?.name = nameLabel.text!
        
        tableView.reloadData()
    }
    
        
    func uploadChangesToFirebase(){
        
        
        for e in thisUser!.employer{
            e.ref!.setValue(e.toAnyObject())
        }
        
        for e in thisUser!.education{
            e.ref!.setValue(e.toAnyObject())
        }
        
        
        thisUser!.ref?.setValue(thisUser!)
        
        
        
        
        
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
        
//        let alert = UIAlertController(title: "Register",
//                                      message: "Register",
//                                      preferredStyle: .alert)
//        
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .default) { action in
//                                        // 1
//                                        let emailField = alert.textFields![0]
//                                        let passwordField = alert.textFields![1]
//                                        
//                                        // 2
//                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
//                                                                   password: passwordField.text!) { user, error in
//                                                                    if error == nil {
//                                                                        // 3
//                                                                        FIRAuth.auth()!.signIn(withEmail: emailField.text!,
//                                                                                               password:  passwordField.text!)
//                                                                    }
//                                        }
//                                        
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default)
//        
//        alert.addTextField { textEmail in
//            textEmail.placeholder = "Enter your email"
//        }
//        
//        alert.addTextField { textPassword in
//            textPassword.isSecureTextEntry = true
//            textPassword.placeholder = "Enter your password"
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Update",
                                      message: "Register",
                                      preferredStyle: .alert)
        var itemChanged = ""
        var selectedIndex = segmentedControl.selectedSegmentIndex
        let nameField = alert.textFields![0]
        var positionField: UITextField
        var degreeField: UITextField
        var majorField: UITextField
        var graduationYearField: UITextField
        var newRef: FIRDatabaseReference
        
        if selectedIndex == 0 {
            itemChanged = "work experience"
            alert.message = "Add new \(itemChanged)"
            let positionField = alert.textFields![1]
            nameField.placeholder = "Where did you work?"
            positionField.placeholder = "Your Role"
            
            
        }
            
        else if selectedIndex == 1 {
            itemChanged = "interest"
            alert.message = "Add new \(itemChanged)"
            nameField.placeholder = "what are you interested in?"
        }
            
        else {
            itemChanged = "education item"
            alert.message = "Add new \(itemChanged)"
            nameField.placeholder = "Where did you go to school?"
            
             degreeField = alert.textFields![1]
             majorField = alert.textFields![2]
             graduationYearField = alert.textFields![3]
            
            degreeField.placeholder = "What level was your degree?"
            majorField.placeholder = "Major"
            graduationYearField.placeholder = "Graduation Year"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default){ action in
            if selectedIndex == 0{
                var newEmployer = Employer(name: self.nameTextField.text!, position: positionField.text!)
                self.thisUser?.employer.append(newEmployer)
                newRef = (employerRef?.childByAutoId())!
                newEmployer.ref = newRef
                newRef.setValue(newEmployer.toAnyObject())
            }
            else if selectedIndex == 1{
                var newEducation = 
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
    }
    
    @IBAction func segmentButton(_ sender: AnyObject) {
        tableView.reloadData()
    }
    

}






// MARK: TABLEVIEW DELEGATE FUNCTIONS + CELL DELEGATE

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalCell") as! PersonalTableViewCell
        
        //cell.delegate = self
        cell.canEdit = self.canEdit
        cell.savedChanges = self.savedChanges
        cell.saveRequested = self.saveRequested
        cell.thisRow = indexPath.row
        cell.delegate = self
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if !saveRequested{
                
                cell.itemLabel.text = self.thisUser!.employer[indexPath.row].name
                cell.descriptionLabel.text = self.thisUser!.employer[indexPath.row].position
                let logo = self.thisUser!.employer[indexPath.row].logo
                
                if logo != ""{
                    cell.imageView?.image = Helper.dataStringToImage(dataString: logo)
                }
            
                cell.source = "experience"
            }
        }
            
        else if segmentedControl.selectedSegmentIndex == 1 {
            if !saveRequested{
                cell.itemLabel.text = self.thisUser!.interests[indexPath.row]
                cell.descriptionLabel.text = ""
            cell.source = "interests"
        }
    }
            
        else {
            if !saveRequested{
                cell.itemLabel.text = self.thisUser!.education[indexPath.row].school
                cell.itemLabel.text = self.thisUser!.education[indexPath.row].major + ", " + self.thisUser!.education[indexPath.row].type.rawValue                
                }
                
            cell.source = "academic"
        }
        
        self.saveRequested = false
        cell.buildCell()
        return cell
    }
    
    func getUser() -> User {
        return self.thisUser!
    }
    
    func changesMade(changed: Bool){
        changesMade = changed
    }


    
}




