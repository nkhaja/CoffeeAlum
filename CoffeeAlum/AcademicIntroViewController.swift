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
    var school:String?
    var major: String?
    var data: [String:Any] =  Dictionary()
    var pickerDataSource = ["BSc", "BA", "BBA", "MSc", "MA", "PhD", "MD", "JD", "DDS"]
    var years:[String] = Array()
    var degree: DegreeType?
    var year: String?
    
    // MARK: ALERTS
    
    let alert = UIAlertController(title: "Fields left unfilled",
                                  message: "Please fill out all fields",
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
   

    @IBOutlet weak var pickerView2: UIPickerView!
   
    
    @IBOutlet weak var degreeLabel: DesignableLabel!
    @IBOutlet weak var miniView: UIView!
    
    @IBOutlet weak var schoolTextField: DesignableTextField!
    @IBOutlet weak var majorTextField: DesignableTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //ALERTs
        alert.addAction(okAction)
        //Hide PickerView
        self.miniView.isHidden = true
        for i in 1950...2040 {
            years.append(String(i))
        }
        
        
        // Set Defaults for the PickerView
        let defaultDegree = "BSc"
        let defaultYear = "1990"
        
        let defaultDegreeIndex = pickerDataSource.index(of: defaultDegree)
        let defaultYearIndex = years.index(of: defaultYear)
        pickerView2.selectRow(defaultDegreeIndex!, inComponent: 0, animated: false)
        pickerView2.selectRow(defaultYearIndex!, inComponent: 1, animated: false)

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profile" {
            if let pictureIntroViewController = segue.destination as? PictureIntroViewController{
                let educationStruct = Education(school: self.school!, graduationYear: self.year!, major: majorTextField.text!, type: self.degree!)
                
                data["education"] = educationStruct
                pictureIntroViewController.data = self.data
            }
        }
        
    }
    
    
    
    
    
    
   // PICKERVIEW FUNCTIONS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return pickerDataSource.count
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
            return years[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            degree = DegreeType(rawValue: pickerDataSource[row])
        }
        
        else {
            year = String(years[row])
        }
    }
    

    @IBAction func submitButton2(_ sender: AnyObject) {
       // Make sure nil isn't returned == happens when pickersView selected mid-slide
        if !degree!.rawValue.contains("nil") && !year!.contains("nil"){
            
            miniView.isHidden = true
            degreeLabel.text! = "\(degree!.rawValue)," +  "\(year!))"
            
        }
 
        
    }
    
    
    // SUBMIT RESPONSE, DISMISS PICKERVIEW
    
    @IBAction func showPickerButton2(_ sender: AnyObject) {
        miniView.isHidden = false
    }

    

    @IBAction func nextButton2(_ sender: AnyObject) {
        self.school = schoolTextField.text
        self.major = majorTextField.text
        var checkFails = true
        
        if school != nil && major != nil {
            let shortSchool = school!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            let shortMajor = major!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            
            checkFails = shortSchool == "" || shortSchool.length < 2 || shortMajor == "" || shortMajor.length < 2
        }
        
        
        
        if checkFails{
            
            self.present(alert, animated: true, completion: nil)
        }
            
        else{
            performSegue(withIdentifier: "profile", sender: self)
        }
    }
    
    
    

}
