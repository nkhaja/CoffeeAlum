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
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil{
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    

    @IBAction func loginDidTouch(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!){ success in
                                if success.0 != nil{
                                    self.newUser = false
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
        performSegue(withIdentifier: "intro", sender: nil)
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

