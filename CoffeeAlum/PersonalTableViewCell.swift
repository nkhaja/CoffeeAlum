//
//  PersonalTableViewCell.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-10.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

protocol CellDataDelegate {
    func updateEdits(index:Int, source: String)
    func getUser() -> User
    func editsAllowed() -> Bool
}

class PersonalTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var itemLabel: DesignableLabel!
    @IBOutlet weak var descriptionLabel: DesignableLabel!
    @IBOutlet weak var itemImage: DesignableImageView!
    @IBOutlet weak var itemTextField: DesignableTextField!
    @IBOutlet weak var descriptionTextfield: DesignableTextField!
    @IBOutlet weak var itemImageView: DesignableImageView!
    
    var source: String?
    var index: Int?
    var delegate: CellDataDelegate?
    var canEdit:Bool = false
    var savedChanges: Bool = true

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemTextField.delegate = self
        itemTextField.isHidden = true
        itemLabel.isUserInteractionEnabled = true
        
        descriptionTextfield.delegate = self
        descriptionTextfield.isHidden = true
        descriptionLabel.isUserInteractionEnabled = true
        
        
        let aSelector : Selector = "labelTapped"
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        itemLabel.addGestureRecognizer(tapGesture)
        descriptionLabel.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func editItemButton(_ sender: DesignableButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        itemTextField.isHidden = true
        descriptionTextfield.isHidden = true
        itemLabel.isHidden=false
        descriptionLabel.isHidden = false
        itemLabel.text = itemTextField.text
        descriptionTextfield.text = descriptionLabel.text
        return true
    }
    
    func labelTapped(){
        itemLabel.isHidden = true
        itemTextField.isHidden = false
        itemTextField.text = itemLabel.text
        
        descriptionLabel.isHidden = true
        descriptionTextfield.isHidden = false
        descriptionTextfield.text = descriptionLabel.text
    }
    

}
