//
//  User.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User {
    var name:String
    var account:AccountType
    var employer: [Employer] = []
    var location: String = ""
    var workHistory: [String] = []
    var education: [Education] = []
    var interests: [Interest] = []
    var coffees: [Coffee] = []
    var portrait: String = ""
    var email: String = ""
    var uid: String = ""
    var key: String = ""
    var ref: FIRDatabaseReference?
    
    init(name:String, account:AccountType){
        self.name = name
        self.account = account
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        account = AccountType(rawValue: snapshotValue["account"] as! String)!
        
        let employerData = snapshot.childSnapshot(forPath: "employer")
        for item in employerData.children {
            let value = item as! FIRDataSnapshot
            let thisEmployer = Employer(snapshot: value)
            employer.append(thisEmployer)
        }
        
        if let locationData = snapshotValue["location"]{
            location = locationData as! String
        }
        
        if let workHistoryData = snapshotValue["workHistory"] {
            workHistory = workHistoryData as! [String]
        }
        
        let educationData = snapshot.childSnapshot(forPath: "academic")
        for item in educationData.children{
            let value = item as! FIRDataSnapshot
            let thisEducation = Education(snapshot: value)
            education.append(thisEducation)
        }
        
        if let interestsData = snapshotValue["interests"] {
            for item in interestsData.children {
                let value = item as! FIRDataSnapshot
                let thisInterest = Interest(snapshot: value)
                interests.append(thisInterest)
            }
        }
        
        if let coffeeIdsData = snapshotValue["coffees"] {
            for item in coffeeIdsData.children{
                let value = item as! FIRDataSnapshot
                let thisCoffee = Coffee(snapshot: value)
                coffees.append(thisCoffee)
            }
        }
        
        if let portraitsData = snapshotValue["portrait"]{
            portrait = portraitsData as! String
        }
        
        if let emailData = snapshotValue["email"]{
            email = emailData as! String 
        }
        
        if let uidata = snapshotValue["uid"]{
            uid = uidata as! String
        }
        
        key = snapshot.key
        ref = snapshot.ref
    }
    
    func toAnyObject() -> NSDictionary{
        
        return [
        "name": name,
        "account": account.rawValue,
        //"employer" : employer,
        "location": location, 
        "workHistory": workHistory,
        //"interests": interests,
        //"coffeeIds": coffeeIds,
        "portrait": portrait,
        "uid": uid
        ]
    }
   
}

enum AccountType: String {
    case student = "student"
    case alumni = "alumni"
    case admin = "admin"
}




