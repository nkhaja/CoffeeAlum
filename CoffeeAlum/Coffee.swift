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
    var fromId: String // name of user that sent invitation
    var toId: String   // name of user that received invitation
    var accepted: Bool = false
    var key: String = ""
    var ref: FIRDatabaseReference?
    
    init(date: Date, time:Date, location: String, fromId:String, toId: String){
        self.date = date
        self.time = time
        self.location = location
        self.fromId = fromId
        self.toId = toId
    }
    
    init(snapshot:FIRDataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        date = snapshotValue["date"] as! Date
        time = snapshotValue["time"] as! Date
        location = snapshotValue["location"] as! String
        fromId = snapshotValue["fromId"] as! String
        toId = snapshotValue["toId"] as! String
        accepted = snapshotValue["accepted"] as! Bool
        key = snapshot.key
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any{
        return [
            "date":date,
            "time":time,
            "location":location,
            "fromId":fromId,
            "toId": toId,
            "accepted":accepted
        ]
    }
  
}
