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
    
    // MARK: - Required Variables
    var school: String?
    var major: String?
    var data: [String : Any] =  Dictionary()
    var pickerDataSource = ["BSc", "BA", "BBA", "MSc", "MA", "PhD", "MD", "JD", "DDS"]
    var years: [String] = Array()
    var degree: DegreeType?
    var year: String?
    
    // MARK: - Alerts
    let alert = UIAlertController(title: "Fields left unfilled",
                                  message: "Please fill out all fields",
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    // MARK: - IBOutlets
    // Picker view to display the academic majors
    @IBOutlet weak var academicMajorPickerView: UIPickerView!
    
    // degree label displays the selected degree
    @IBOutlet weak var degreeLabel: DesignableLabel!
    
    // schoolTextField displays the user's school name
    @IBOutlet weak var schoolTextField: DesignableTextField!
    
    // majorTextField displays the user's selected major
    @IBOutlet weak var majorTextField: DesignableTextField!
    
    
    // MARK: - View Did Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sends an alert in the view
        alert.addAction(okAction)
        // Sets out the range of the dates in String format
        for i in 1950...2040 {
            years.append(String(i))
        }
        // Set Defaults for the PickerView
        let defaultDegree = "BSc"
        let defaultYear = "1990"
        // Setting the defaultDegree as the picker view's default state
        let defaultDegreeIndex = pickerDataSource.index(of: defaultDegree)
        let defaultYearIndex = years.index(of: defaultYear)
        academicMajorPickerView.selectRow(defaultDegreeIndex!, inComponent: 0, animated: false)
        academicMajorPickerView.selectRow(defaultYearIndex!, inComponent: 1, animated: false)
    }

    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profile" {
            if let pictureIntroViewController = segue.destination as? PictureIntroViewController{
                let educationStruct = Education(school: self.school!, graduationYear: self.year!, major: majorTextField.text!, type: self.degree!)
                
                data["education"] = educationStruct
                pictureIntroViewController.data = self.data
            }
        }
        
    }
    
   // MARK: - Pickerview Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return pickerDataSource.count
        } else {
            return years.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerDataSource[row]
        } else {
            return years[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            degree = DegreeType(rawValue: pickerDataSource[row])
        } else {
            year = String(years[row])
        }
    }
    
    // MARK: - IBActions
    // Submit button after the user has selected the degree
    @IBAction func submitButton2(_ sender: AnyObject) {
       // Make sure nil isn't returned == happens when pickersView selected mid-slide
        if !degree!.rawValue.contains("nil") && !year!.contains("nil"){
            degreeLabel.text! = "\(degree!.rawValue)," +  "\(year!))"
        }
    }
    
    
    // Submit response, dimiss the picker view
    @IBAction func showPickerButton2(_ sender: AnyObject) {
        // TODO: - Add keyboard that contains PickerView
    }

    
    @IBAction func academicIntroNextButton(_ sender: AnyObject) {
        self.school = schoolTextField.text
        self.major = majorTextField.text
        var checkFails = true
        
        if school != nil && major != nil {
            let shortSchool = school!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            let shortMajor = major!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            
            checkFails = shortSchool == "" || shortSchool.length < 2 || shortMajor == "" || shortMajor.length < 2
        }
    
        if checkFails {
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "profile", sender: self)
        }
    }
    
}
