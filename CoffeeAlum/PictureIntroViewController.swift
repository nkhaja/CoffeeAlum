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
    
    var userRef:FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")
    var newUser: User?
    
    var data: [String:Any] =  Dictionary()
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "connect"{
            if let cvc = segue.destination as? ConnectViewController{
                cvc.thisUser = newUser
            }
        }
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        data["portrait"] = Helper.imageToDataString(image: profileImageView.image!)
        
        let name:String = data["name"] as! String
        let accountType = data["accountType"] as! AccountType
        let city:String = data["city"] as! String
        let state = data["state"] as! String
        let education:Education = data["education"] as! Education
        let employer = data["employer"] as! Employer
        let portrait = data["portrait"] as! String
        let uid = data["uid"] as! String
        
        self.newUser = User(name: name, account: accountType)
        if let newUser = newUser{
            newUser.location = city
            newUser.education.append(education)
            newUser.employer.append(employer)
            newUser.portrait = portrait
            
            let newUserRef = userRef.child(uid)
            let employerRef = newUserRef.child("employer")
            let academicRef = newUserRef.child("academic")
            newUserRef.setValue(newUser.toAnyObject())
            employerRef.setValue(employer.toAnyObject())
            academicRef.setValue(education.toAnyObject())
        }
        
        performSegue(withIdentifier: "connect", sender: self)
        
    }


    
    

}
