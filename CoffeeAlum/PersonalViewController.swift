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


//TODO: Block Add feature when edit mode is enabled.
// - Employer is selected as just the first in the list. Need to make it so that most recent employer is identified and used instead.


class PersonalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    var thisUser:User?
    
    var thisUserRef: FIRDatabaseReference?
    var employerRef: FIRDatabaseReference?
    var educationRef: FIRDatabaseReference?
    var interestRef: FIRDatabaseReference?
    
    var tbc: CustomTabBarController?
    var interests: [String] = []
    var academic: [String] = []
    var employment: [Employer] = []
    
    var canEdit:Bool = false
    var changesMade = false
    var saveRequested: Bool = false
    var savedChanges:Bool = true
    var cellPictureChanging: (Bool,String,Int) = (false, "", 0)
    var newName:String?
    var newCareer: String?
    var newLocation: String?
    
    
    // MARK: Outlets - Labels
    @IBOutlet weak var nameLabel: DesignableLabel!
    @IBOutlet weak var careerLabel: DesignableLabel!
    @IBOutlet weak var locationLabel: DesignableLabel!
    
    
    
    // MARK: Special - Outlets
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Outlets - TextFields
    @IBOutlet weak var nameTextField: DesignableTextField!
    @IBOutlet weak var careerTextField: DesignableTextField!
    @IBOutlet weak var locationTextField: DesignableTextField!
    
    @IBOutlet weak var pictureButtonPressed: DesignableButton!
    
    
    
    
    //ImagePicker
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Set References
        
        
        imagePicker.delegate = self
        if let tbc = self.tabBarController as? CustomTabBarController{
            self.thisUser = tbc.thisUser
            self.thisUserRef = tbc.thisUserRef
            self.employerRef = thisUserRef?.child("employer")
            self.educationRef = thisUserRef?.child("academic")
            self.interestRef = thisUserRef?.child("interests")
            
            self.profileImageView.image = Helper.dataStringToImage(dataString: self.thisUser!.portrait)
        }
        
        
        nameTextField.delegate = self
        nameTextField.isHidden = true
        nameLabel.text = thisUser?.name
        nameLabel.isUserInteractionEnabled = true
        
        careerTextField.delegate = self
        careerTextField.isHidden = true
        careerLabel.text = thisUser?.employer[0].name
        careerLabel.isUserInteractionEnabled = true
        
        locationTextField.delegate = self
        locationTextField.isHidden = true
        locationLabel.text = thisUser?.location
        locationLabel.isUserInteractionEnabled = true
        
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
            
            careerLabel.isHidden = true
            careerTextField.isHidden = false
            careerTextField.text = careerLabel.text
            
            
            locationLabel.isHidden = true
            locationTextField.isHidden = false
            locationTextField.text = locationLabel.text
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        nameTextField.isHidden = true
        nameLabel.text = nameTextField.text
        nameLabel.isHidden = false
        newName = nameLabel.text
        
        careerTextField.isHidden = true
        careerLabel.text = careerTextField.text
        careerLabel.isHidden = false
        newCareer = careerLabel.text
        
        locationTextField.isHidden = true
        locationLabel.text = careerTextField.text
        locationLabel.isHidden = false
        newLocation = locationLabel.text
        
        
        return true
    }


    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if cellPictureChanging.0 {
                switch cellPictureChanging.1{
                case "experience":
                    thisUser?.employer[cellPictureChanging.2].logo = Helper.imageToDataString(image: pickedImage)
                case "interests":
                    return // TODO: Change this once interests have pictures associated with them
                case "education":
                    thisUser?.education[cellPictureChanging.2].logo = Helper.imageToDataString(image: pickedImage)
                default: return
                }
            
            }
            
            else{
                profileImageView.contentMode = .scaleAspectFit
                profileImageView.image = pickedImage
                thisUser!.portrait = Helper.imageToDataString(image: pickedImage)
                self.profileImageView.image = pickedImage
            }
            
        }
        cellPictureChanging.0 = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        tableView.reloadData() //TODO: Insepect what happens when images are changes while edit mode is on. 
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
        thisUser?.employer[0].name = careerLabel.text! //MUST CHANGE; Does not sync with employment status listed in tableView
        thisUser?.location = locationLabel.text!
        tableView.reloadData()
    }
    
        
    func uploadChangesToFirebase(){
        
        thisUser!.ref?.setValue(thisUser!.toAnyObject())
        for e in thisUser!.employer{
            e.ref!.setValue(e.toAnyObject())
        }
        
        for e in thisUser!.education{
            e.ref!.setValue(e.toAnyObject())
        }
        
        
        
        
        
        
    }

    @IBAction func saveEditsButton(_ sender: AnyObject) {
        if canEdit == false{
            allowEdits()
        }
        else{
            saveEdits()
        }
    }
    
    //MARK: ADD NEW ITEM FUNCTIONALITY
    @IBAction func addItemButton(_ sender: DesignableButton) {
        
        let alert = UIAlertController(title: "Update",
                                      message: "Register",
                                      preferredStyle: .alert)
        var itemChanged = ""
        let selectedIndex = segmentedControl.selectedSegmentIndex
        var newRef: FIRDatabaseReference?
        
        
        // Build Save Button
        let saveAction = UIAlertAction(title: "Save", style: .default){ action in

            if selectedIndex == 0{
                let nameField = alert.textFields![0] as UITextField
                let positionField = alert.textFields![1] as UITextField
                
                //Add new item to current user
                var newEmployer = Employer(name: nameField.text!, position: positionField.text!)
                self.thisUser?.employer.append(newEmployer)
                newRef = (self.employerRef?.childByAutoId())!
                newEmployer.ref = newRef
                newRef?.setValue(newEmployer.toAnyObject())
                
                
            }
            else if selectedIndex == 1 {
                let nameField = alert.textFields![0] as UITextField
                let newInterest = nameField.text
                self.thisUser?.interests.append(newInterest!)
                newRef = self.interestRef?.childByAutoId()
                newRef?.setValue(newInterest)
            }
            
            else{
                let nameField = alert.textFields![0] as UITextField
                let degreeField = alert.textFields![1] as UITextField
                let majorField = alert.textFields![2] as UITextField
                let graduationYearField = alert.textFields![3] as UITextField
                
                let newEducation = Education(school: nameField.text!, graduationYear: graduationYearField.text!, major: majorField.text!, type: DegreeType(rawValue: degreeField.text!)!)
                
                self.thisUser?.education.append(newEducation)
                newRef = self.educationRef?.childByAutoId()
                newRef?.setValue(newEducation.toAnyObject())
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        
        //ADD Textfields with custom placeholders to Alerts
        
        if selectedIndex == 0 {
            itemChanged = "work experience"
            alert.message = "Add new \(itemChanged)"
            
            alert.addTextField{ workNameField in
                workNameField.placeholder = "Where did you work?"
            }
            
            alert.addTextField{ positionField in
                positionField.placeholder = "Your Role"
            }
            
        }
            
        else if selectedIndex == 1 {
            itemChanged = "interest"
            alert.message = "Add new \(itemChanged)"
            
            alert.addTextField{ interestField in
                interestField.placeholder = "What interests you?"
            }
            
        }
            
        else {
            itemChanged = "education item"
            alert.message = "Add new \(itemChanged)"
            
            alert.addTextField{ schoolNameField in
                schoolNameField.placeholder = "School?"
            }
            
            alert.addTextField{ degreeField in
                degreeField.placeholder = "Degree (e.g BSc)"
            }
            
            alert.addTextField{ majorField in
                majorField.placeholder = "Major"
            }
            
            alert.addTextField{ yearField in
                yearField.placeholder = "Grad Year"
            }
        }
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        self.tableView.reloadData()
        
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
                else{
                    cell.itemImageView.image = #imageLiteral(resourceName: "first")
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
                cell.itemLabel.text = self.thisUser!.education[indexPath.row].major + ", " + self.thisUser!.education[indexPath.row].type.rawValue
                cell.descriptionLabel.text = self.thisUser!.education[indexPath.row].school
                
                let logo = self.thisUser!.education[indexPath.row].logo
                if logo != ""{
                    cell.itemImageView.image = Helper.dataStringToImage(dataString: logo)
                }
                else{
                    cell.itemImageView.image = #imageLiteral(resourceName: "first")
                }
                cell.source = "academic"
                }
        }
        
        self.saveRequested = false
        cell.buildCell()
        return cell
    }
    
    func getUser() -> User {
        return self.thisUser!
    }
    
    func changesMade(changed: Bool){
        self.changesMade = changed
    }
    
    func newImageForCell(changing: Bool, segment:String, row:Int){
        self.cellPictureChanging = (changing, segment, row)
        self.changePictureButton(pictureButtonPressed)
        print("imageViewPressed")
    }


    
}




