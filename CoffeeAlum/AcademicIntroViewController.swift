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
    // Stores the user's school name, a type String
    var school: String?
    // Stores the user's major data, a type String
    var major: String?
    // Data is used for
    var data: [String : Any] =  Dictionary()
    // The list of degrees for the pickerView
    var pickerDataSource = ["BSc", "BA", "BBA", "MSc", "MA", "PhD", "MD", "JD", "DDS"]
    // Stores the list of years
    var years: [String] = Array()
    // Stores the degree information, type enum
    var degree: DegreeType?
    // Year variable, takes a type String
    var year: String?
    // Picker view to display the academic majors
    var academicMajorPickerView = UIPickerView()
    
    // MARK: - Alerts
    let alert = UIAlertController(title: "Fields left unfilled",
                                  message: "Please fill out all fields",
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    // MARK: - IBOutlets
    
    // degree label displays the selected degree
    @IBOutlet weak var degreeTextField: DesignableTextField!
    
    // schoolTextField displays the user's school name
    @IBOutlet weak var schoolTextField: DesignableTextField!
    
    // majorTextField displays the user's selected major
    @IBOutlet weak var majorTextField: DesignableTextField!
    
    // MARK: - Methods
    func setDegree(sender: UIPickerView) {
        // Make sure nil isn't returned == happens when pickersView selected mid-slide
        if !degree!.rawValue.contains("nil") && !year!.contains("nil"){
            degreeTextField.text! = "\(degree!.rawValue)," +  "\(year!))"
        }
    }
    
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
        // Setting the defaultDegree as the picker view's default degree
        let defaultDegreeIndex = pickerDataSource.index(of: defaultDegree)
        // Setting the defaultYear as the picker view's default year
        let defaultYearIndex = years.index(of: defaultYear)
        // TODO: - Fix the crash here
        academicMajorPickerView.selectRow(defaultDegreeIndex!, inComponent: 0, animated: false)
        // Sets
        academicMajorPickerView.selectRow(defaultYearIndex!, inComponent: 1, animated: false)
        
        degreeTextField.inputView = academicMajorPickerView
        setDegree(sender: academicMajorPickerView)
        academicMajorPickerView.dataSource = self
        academicMajorPickerView.delegate = self
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
        if component == 0 {
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
