//
//  AccountTypeIntroViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-20.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class AccountTypeIntroViewController: UIViewController{
    var data: [String:Any] =  Dictionary()
    
    let uncheckedImage = #imageLiteral(resourceName: "uncheckedButton")
    let checkedImage = #imageLiteral(resourceName: "checkedButton")
    let otherImage = #imageLiteral(resourceName: "testUser3")
    var studentPressed: Bool = true
    var alumniPressed: Bool = false
    var name:String = ""
    var accountType:AccountType?
    
    @IBOutlet weak var studentButton: DesignableButton!
    @IBOutlet weak var alumniButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if studentPressed{
            studentButton.setImage(checkedImage, for: .selected)
            alumniButton.setImage(uncheckedImage, for: .selected)
        } else {
            studentButton.setImage(uncheckedImage, for: .selected)
            alumniButton.setImage(checkedImage, for: .selected)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "location"{
            if let livc = segue.destination as? LocationIntroViewController{
                data["accountType"] = self.accountType
                livc.data = self.data
            }
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func studentButton(_ sender: AnyObject) {
        studentPressed = true
        alumniPressed = false
        studentButton.setImage(checkedImage, for: .normal)
        alumniButton.setImage(uncheckedImage, for: .normal)
    }
    
    // TODO: - Check if this is setup automatically, if not the user experience might be uncomfortable
    @IBAction func alumniButton(_ sender: AnyObject) {
        studentPressed = false
        alumniPressed = true
        studentButton.setImage(uncheckedImage, for: .normal)
        alumniButton.setImage(checkedImage, for: .normal)
    }
    
    @IBAction func nextButton(_ sender: AnyObject) {
        if studentPressed{
            self.accountType = .student
        } else {
            self.accountType = .alumni
        }
        performSegue(withIdentifier: "location", sender: self)
    }
    
}
