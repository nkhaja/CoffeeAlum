//
//  ViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-19.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

   
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var secondDescriptionTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveChangesButton(_ sender: AnyObject) {
    }
    
}
