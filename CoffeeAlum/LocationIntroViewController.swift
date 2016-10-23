//
//  LocationIntroViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-20.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class LocationIntroViewController: UIViewController {
    var data: [String:Any] =  Dictionary()
    var city: String = ""
    var state: String = ""
    
    @IBOutlet weak var cityTextField: DesignableTextField!
    
    @IBOutlet weak var stateTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "employer"{
            if let eivc = segue.destination as? EmployerIntroViewController{
                data["city"] = self.city
                data["state"] = self.state
                eivc.data = self.data
            }
        }
    }
    
    
    
    
    
    
    @IBAction func nextButton(_ sender: AnyObject) {
        self.city = cityTextField.text!
        self.state = stateTextField.text!
        let shortCity = city.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let shortState = state.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let checkFails = shortCity == "" || shortCity.length < 2 || shortState == "" || shortState.length < 2
        
        

        
        if checkFails{
            let alert = UIAlertController(title: "Invalid City or State Name",
                                          message: "please verify that you have entered approproate location names",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
            performSegue(withIdentifier: "employer", sender: self)
        }
    }
    
    


}
