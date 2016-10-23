//
//  EmployerIntroViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-20.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class EmployerIntroViewController: UIViewController {
    var data: [String:Any] =  Dictionary()
    var employerName = ""
    var role = ""

    @IBOutlet weak var employerTextField: DesignableTextField!
    @IBOutlet weak var roleTextField: DesignableTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "academic"{
            if let aivc = segue.destination as? EmployerIntroViewController{
                let employerStruct = Employer(name: self.employerName, position: self.role)
                data["employer"] = employerStruct
                aivc.data = self.data
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func nextButton(_ sender: AnyObject) {
        self.employerName = employerTextField.text!
        self.role = roleTextField.text!
        let shortEmployerName = employerName.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let shortRole = role.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let checkFails = shortEmployerName == "" || shortEmployerName.length < 2 || shortRole == "" || shortRole.length < 2
        
   
        if checkFails{
            let alert = UIAlertController(title: "Fields left unfilled",
                                          message: "Please fill out all fields",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
            
        else{
            performSegue(withIdentifier: "academic", sender: self)
        }
    }
}
