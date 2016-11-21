//
//  Employer.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Employer{
    var name: String
    var position: String
    var companySummary: String = ""
    var positionSummary: String = ""
    var logo: String = ""
    var key: String = ""
    var ref: FIRDatabaseReference?
    
    init(name: String, position: String){
        self.name = name
        self.position = position
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        position = snapshotValue["position"] as! String
        
        if let companySummaryData = snapshotValue["companySummary"]{
            companySummary = companySummaryData as! String
        }
        
        if let positionSummaryData = snapshotValue["positionSummary"]{
            companySummary = positionSummaryData as! String
        }
        
        if let logoData = snapshotValue["logo"]{
            logo = logoData as! String
        }
    }
    
    func toAnyObject() -> Any{
        return [
            "name":name,
            "position":position,
            "companySummary":companySummary,
            "positionSummary":positionSummary,
            "logo": logo
        ]
    }
    
    
}


enum forWhom {
    case from
    case to
}






