//
//  MailViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-03.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import Spring
class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var thisUser:User? = nil
    var thisUserRef: FIRDatabaseReference? = nil
    var recipientUser:User? = nil
    var coffeeRef = FIRDatabase.database().reference(withPath: "coffees")

    @IBOutlet weak var subjectLineTextField: DesignableTextField!
    @IBOutlet weak var emailBodyTextView: DesignableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController{
            tbc.thisUser = self.thisUser
            tbc.thisUserRef = self.thisUserRef
        }
    }
   
    
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        
        // MARK: Temporary so I can test the coffee making option beforehand
        let newCoffee = Coffee(fromId: thisUser!.uid, fromName: thisUser!.name, toId: recipientUser!.uid, toName: recipientUser!.name)
        coffeeRef.childByAutoId().setValue(newCoffee.toAnyObject())
        
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 2
        
        if MFMailComposeViewController.canSendMail() {
        
            
            self.present(mailComposeViewController, animated: true, completion: nil)
            
            let newCoffee = Coffee(fromId: thisUser!.uid, fromName: thisUser!.name, toId: recipientUser!.uid, toName: recipientUser!.name)
            coffeeRef.childByAutoId().setValue(newCoffee.toAnyObject())
        }
        
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([self.recipientUser!.email])
        mailComposerVC.setSubject("CoffeeAlum: \(subjectLineTextField.text!)")
        let bodyString = "\(emailBodyTextView.text)" +
            "Sent via the \(thisUser?.name)'s iPhone from CoffeeAlum" +
            "You can reach this user at \(thisUser!.email)"
        mailComposerVC.setMessageBody(bodyString, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration or internet connection and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }



}
