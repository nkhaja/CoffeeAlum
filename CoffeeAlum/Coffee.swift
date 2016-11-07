//
//  Coffee.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import Firebase

struct Coffee {
    var date: Date
    var time: Date
    var location: String
    var guest: String
    var host: String
    var key: String = ""
    var ref: FIRDatabaseReference?
    
    init(date: Date, time:Date, location: String, guest:String, host: String){
        self.date = date
        self.time = time
        self.location = location
        self.guest = guest
        self.host = host
    }
    
    init(snapshot:FIRDataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        date = snapshotValue["date"] as! Date
        time = snapshotValue["time"] as! Date
        location = snapshotValue["location"] as! String
        guest = snapshotValue["guest"] as! String
        host = snapshotValue["host"] as! String
        key = snapshot.key
        ref = snapshot.ref
    }
  
}
