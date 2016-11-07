//
//  Interest.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-05.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import UIKit
import Firebase


struct Interest{
    var name:String = ""
    var picture: String = ""
    var key:String = ""
    var ref: FIRDatabaseReference?
    
    init(name:String){
        self.name = name
    }
    
    
    init(snapshot: FIRDataSnapshot){
        let snapshotValue = snapshot.value as! [String:AnyObject]
        name = snapshotValue["name"] as! String
        
        if let picture = snapshotValue["picture"] as? String{
            self.picture = picture
        }
    }
    
    func toAnyObject() -> NSDictionary{
            return [
                "name":name,
                "logo": picture
            ]
    }
    
}

