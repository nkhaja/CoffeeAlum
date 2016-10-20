//
//  LoginViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-07.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var newUser:Bool = false
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        newUser = false
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil{
                if self.newUser == true{
                    self.performSegue(withIdentifier: self.loginToList, sender: nil)

                }
                
                else {
                    
                }
            }
        }
    }
    
    
    // MARK: Actions

    @IBAction func loginDidTouch(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!){ success in
                                if success.0 != nil{
                                    self.performSegue(withIdentifier: self.loginToList, sender: nil)
                                }
                                    
                                else if success.1 != nil{
                                    let alert = UIAlertController(title: "Login Failed",
                                                                  message: success.1!.localizedDescription,
                                                                  preferredStyle: .alert)
                                    
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                else{
                                    
                                let alert = UIAlertController(title: "Login Failed",
                                                                  message: "Your Username or Password is incorrect",
                                                                  preferredStyle: .alert)
                    
                                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                
        }
        
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        // 1
                                        newUser = true
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        // 2
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        // 3
                                                                        FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                                                                               password: self.textFieldLoginPassword.text!)
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
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue){
        newUser = false
    }

    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

