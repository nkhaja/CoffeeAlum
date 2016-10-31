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
    func getUser() -> User
    func changesMade(changed: Bool)
    func uploadChangesToFirebase()
}

class PersonalTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var itemLabel: DesignableLabel!
    @IBOutlet weak var descriptionLabel: DesignableLabel!
    @IBOutlet weak var itemImage: DesignableImageView!
    @IBOutlet weak var itemTextField: DesignableTextField!
    @IBOutlet weak var descriptionTextfield: DesignableTextField!
    @IBOutlet weak var itemImageView: DesignableImageView!
    
    var source: String?
    var thisRow: Int?
    var delegate: CellDataDelegate?
    var canEdit:Bool = false
    var savedChanges: Bool = false
    var saveRequested: Bool = false

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buildCell(){
        
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
        updateUser()
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
        if canEdit{
            itemLabel.isHidden = true
            itemTextField.isHidden = false
            itemTextField.text = itemLabel.text
            
            descriptionLabel.isHidden = true
            descriptionTextfield.isHidden = false
            descriptionTextfield.text = descriptionLabel.text
            delegate?.changesMade(changed: true)
        }
        
    }
    
    func updateUser(){
        if saveRequested == true{
        let updatedUser = delegate!.getUser()
        switch source!{
            case "experience":
                updatedUser.employer[thisRow!].name = itemLabel.text!
            case "academic":
                updatedUser.education[thisRow!].school = itemLabel.text!
            case "interests":
                updatedUser.interests[thisRow!] = itemLabel.text!
        default: return
            }
            self.saveRequested = false
            delegate?.uploadChangesToFirebase()
        }
    }
    

}
