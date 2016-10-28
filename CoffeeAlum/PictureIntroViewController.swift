//
//  PictureIntroViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-24.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring 
import Firebase

class PictureIntroViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    //User's Variables
    
    var name:String?
    var accountType: AccountType?
    var city: String?
    var state: String?
    var employer: Employer?
    var education: Education?
    var portrait: String?
    var uid: String?
    
    // DATABASE REFERENCES
    var newUserRef: FIRDatabaseReference?
    var employerRef: FIRDatabaseReference?
    var educationRef: FIRDatabaseReference?
    
    
    
    let userRef:FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")
    var newUser: User?
    var success:Bool?
    
    var data: [String:Any] =  Dictionary()
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil{
                self.uid = user?.uid
                self.buildUser()
                self.setReferences()
                self.newUser?.uid = self.uid!
                
                self.newUserRef!.setValue(self.newUser!.toAnyObject())
                self.employerRef!.setValue(self.employer!.toAnyObject())
                self.educationRef!.setValue(self.education!.toAnyObject()){(error, ref) -> Void in
                    self.performSegue(withIdentifier: "connect", sender: self)
                }
                
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "connect"{
            if let cvc = segue.destination as? ConnectViewController{
                cvc.thisUser = newUser
            }
        }
    }
    
    
    func buildUser(){
        data["portrait"] = Helper.imageToDataString(image: profileImageView.image!)
        name = data["name"] as? String
        accountType = data["accountType"] as? AccountType
        city = data["city"] as? String
        state = data["state"] as? String
        education = data["education"] as? Education
        employer = data["employer"] as? Employer
        portrait = data["portrait"] as? String
        //uid = data["uid"] as? String
        
        self.newUser = User(name: name!, account: accountType!)
        if let newUser = newUser{
            newUser.location = city!
            newUser.education.append(education!)
            newUser.employer.append(employer!)
            newUser.portrait = portrait!
        }
    }
    
    func setReferences(){
         self.newUserRef = userRef.child(uid!)
         self.employerRef = newUserRef!.child("employer").childByAutoId()
         self.educationRef = newUserRef!.child("academic").childByAutoId()
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        register()
        
        
        
    }
    
    
    func register(){
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
            // 1
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            // 2
            FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                       password: passwordField.text!) { user, error in
                                        if error == nil {
                                            // 3
                                            FIRAuth.auth()!.signIn(withEmail: emailField.text!,
                                                                   password:  passwordField.text!)
                                        }
                    }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }


    
    

}
