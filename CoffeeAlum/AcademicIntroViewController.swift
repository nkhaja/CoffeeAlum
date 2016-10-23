//
//  AcademicIntroViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-20.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class AcademicIntroViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var data: [String:Any] =  Dictionary()
    var pickerDataSource = ["BSc", "MSc", "PhD", "MD", "JD", "DDS"]
    var years:[Int] = Array()
    var degree: DegreeType?
    var year: String?

   
    @IBOutlet weak var degreeLabel: UIButton!
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.miniView.isHidden = true
        for i in 1950...2030 {
            years.append(i)
        }
    }

    
    
    
    
    
    
   // PICKERVIEW FUNCTIONS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return pickerDataSource.count;
        }
        else{
            return years.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        if component == 0 {
            return pickerDataSource[row]
        }
        
        else{
            return String(years[row])
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            degree = DegreeType(rawValue: pickerDataSource[row])
        }
        
        else{
            year = String(years[row])
        }
    }
    
    @IBAction func submitButton(_ sender: AnyObject) {
        miniView.isHidden = true
        degreeLabel.text = "\(degree?.rawValue) +,  \(String(year))"
    }
    
    
    // SUBMIT RESPONSE, DISMISS PICKERVIEW
    
    @IBAction func showPickerButton(_ sender: AnyObject) {
        miniView.isHidden = false
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
