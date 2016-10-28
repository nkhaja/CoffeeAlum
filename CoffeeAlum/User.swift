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
    let name:String
    let account:AccountType
    var employer: [Employer] = []
    var location: String = ""
    var workHistory: [String] = []
    var education: [Education] = []
    var interests: [String] = []
    var coffeeIds: [String] = []
    var portrait: String = ""
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
        
        if let employerData = snapshotValue["employer"] as? NSArray{
            for value in employerData {
                let value = value as! NSDictionary
                let employerName = value["name"] as! String
                let employerPosition = value["position"] as! String
                let thisEmployer = Employer(name: employerName, position: employerPosition)
                employer.append(thisEmployer)
            }
            

            

        }
        
        if let locationData = snapshotValue["location"]{
            location = locationData as! String
        }
        
        if let workHistoryData = snapshotValue["workHistory"] {
            workHistory = workHistoryData as! [String]
        }
        
        if let educationData = snapshotValue["academic"] as? NSArray { // UPDATE: to "Education="//
            for value in educationData {
                let value = value as! NSDictionary
                let schoolName = value["school"] as! String
                let graduationYear = value["graduationYear"] as! String
                let major = value["major"] as! String
                let degree = DegreeType(rawValue: value["type"] as! String)

                let thisEducation = Education(school: schoolName, graduationYear: graduationYear, major: major, type: degree!)
                education.append(thisEducation)
            }
            
        }
        
        
        
        if let interestsData = snapshotValue["interests"] {
            interests = interestsData as! [String]
        }
        
        if let coffeeIdsData = snapshotValue["coffeeIds"] {
            coffeeIds = coffeeIdsData as! [String]
        }
        
        if let portraitsData = snapshotValue["portrait"]{
            portrait = portraitsData as! String
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
        "interests": interests,
        "coffeeIds": coffeeIds,
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




