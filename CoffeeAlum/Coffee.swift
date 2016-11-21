//
//  Coffee.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import Firebase

class Coffee {
    var date: String = "TBD"
    var time: String = "TBD"
    var dateSent: String
    var location: String = "TBD"
    var fromId: String
    var toId: String
    var fromName: String // name of user that sent invitation
    var toName: String  // name of user that received invitation
    var fromEventId: String = "" // the id stored locally when the user creates this meeting
    var toEventId: String = ""
    
    var accepted: Bool = false
    var viewed: Bool = false
    var rescheduled: Bool = false
    var key: String = ""
    var ref: FIRDatabaseReference?
    

    init(fromId:String, fromName:String, toId: String, toName: String){
        self.fromId = fromId
        self.toId = toId
        self.fromName = fromName
        self.toName = toName
        self.dateSent = Date().convertToString()
    }
    
    init(date: String, time:String, location: String, fromId:String, toId: String,fromName:String, toName: String){
        self.date = date
        self.time = time
        self.location = location
        self.fromId = fromId
        self.toId = toId
        self.fromName = fromName
        self.toName = toName
        self.dateSent = Date().convertToString()
    }
    
    init(snapshot:FIRDataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        date = snapshotValue["date"] as! String
        time = snapshotValue["time"] as! String
        dateSent = snapshotValue["dateSent"] as! String
        location = snapshotValue["location"] as! String
        fromId = snapshotValue["fromId"] as! String
        toId = snapshotValue["toId"] as! String
        fromName = snapshotValue["fromName"] as! String
        toName = snapshotValue["fromName"] as! String
        fromEventId = snapshotValue["fromEventId"] as! String
        toEventId = snapshotValue["toEventId"] as! String
        accepted = snapshotValue["accepted"] as! Bool
        viewed = snapshotValue["viewed"] as! Bool
        rescheduled = snapshotValue["rescheduled"] as! Bool
        key = snapshot.key
        ref = snapshot.ref
    }
    
    
    func toAnyObject() -> Any{
        return [
            "date":date,
            "time":time,
            "dateSent": dateSent,
            "location":location,
            "fromId":fromId,
            "toId": toId,
            "fromName": fromName,
            "toName": toName,
            "fromEvenId": fromEventId,
            "toEvenId":toEventId,
            "accepted": accepted,
            "viewed": viewed,
            "rescheduled": rescheduled
        ]
    }
    
}

enum CoffeeRole {
    case from
    case to
}
