//
//  nameIntroViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-20.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class NameIntroViewController: UIViewController, UITextFieldDelegate {
    var data: [String:Any] =  Dictionary()
    var name: String = ""
    
    @IBOutlet weak var nameLabel: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameLabel.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "account"{
            if let atvc = segue.destination as? AccountTypeIntroViewController{
                data["name"] = self.name
                atvc.data = self.data
            }
        }
    }


    @IBAction func nextButton(_ sender: AnyObject) {
        self.name = nameLabel.text!
        let charSet = CharacterSet(charactersIn: " ")
        let shortName = name.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let containsSpace = self.name.lowercased().rangeOfCharacter(from: charSet)
        
        // Warning if the name is too short
        if shortName == "" || shortName.length < 2 || containsSpace == nil {
            let alert = UIAlertController(title: "Invalid Name",
                                          message: "Your name must be two or more letters long, or You have not included both names",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
    
        } else {
            performSegue(withIdentifier: "account", sender: self)
        }
    }
    
}
