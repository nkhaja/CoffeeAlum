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
    
    func resetPassWord(){
        
        // CREATE ALERTS
        let resetAlert = UIAlertController(title: "Password Reset",
                                      message: "Please enter your CoffeeAlum email",
                                      preferredStyle: .alert)
        
        let badEmailAlert = UIAlertController(title: "Invalid Email", message: "There is no CoffeeAlum account for this email", preferredStyle: .alert)
        
        let successfulChangeAlert = UIAlertController(title: "Success", message: "A password reset link has been sent to your email", preferredStyle: .alert)
        
        // CREATE ACTIONS
        let sendAction = UIAlertAction(title: "Rest", style: .default ){ action in
            let emailField = resetAlert.textFields![0]
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!) { error in
                if error != nil{
                    self.present(badEmailAlert, animated: true, completion: nil)
                }
                else{
                    self.present(successfulChangeAlert, animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        
        // ADD ACTIONS AND TEXTFIELDS
        resetAlert.addAction(sendAction)
        resetAlert.addAction(cancelAction)
        badEmailAlert.addAction(okAction)
        successfulChangeAlert.addAction(okAction)
        
        resetAlert.addTextField { textEmail in
            textEmail.placeholder = "Enter your CoffeeAlum email"
        }
        
        present(resetAlert, animated: true, completion: nil)
        
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

