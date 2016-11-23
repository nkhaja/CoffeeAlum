//
//  NabilUtility.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-12.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class Helper {

 //Image Helpers

 static func imageToDataString(image: UIImage) -> String{
    var data = Data()
    data = UIImageJPEGRepresentation(image, 0.8)!
    let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    return base64String
    }

    static func dataStringToImage(dataString: String) -> UIImage {
        let data = Data(base64Encoded: dataString, options: .ignoreUnknownCharacters)
        let image = UIImage(data: data!)
        return image!
    }
    
    // Date Helpers:
    
    static func stringToDate(date:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm Z"
        return dateFormatter.date(from: date)!
    }
    

    
    // Event Helper Functions
    
    static func createEvent(eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) -> String {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            let savedEventId = event.eventIdentifier
            return savedEventId
        } catch {
            print("Bad things happened")
            return ""
        }
    }
    
    // Removes an event from the EKEventStore. The method assumes the eventStore is created and accessible
    
    static func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }
    

    
    // Responds to button to add event. This checks that we have permission first, before adding the event
    static func addEvent(startDate:Date, coffeeWith: String, coffee:Coffee, role: CoffeeRole){
        let eventStore = EKEventStore()
        
        let endDate = startDate.addingTimeInterval(60 * 60 / 2) // 30 mins
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                
                if role == .to{
                    coffee.toEventId = createEvent(eventStore: eventStore, title: "Coffee with \(coffeeWith)", startDate: startDate, endDate: endDate)
                    
                    coffee.rescheduled = true
                }
                
                else if coffee.fromEventId == "" || coffee.rescheduled{
                    coffee.fromEventId = createEvent(eventStore: eventStore, title: "Coffee with \(coffeeWith)", startDate: startDate, endDate: endDate)
                }
            
            })
        }
        
        else {
            
            if role == .to{
                coffee.toEventId = createEvent(eventStore: eventStore, title: "Coffee with \(coffeeWith)", startDate: startDate, endDate: endDate)
                
                coffee.rescheduled = true
            }
                
            else if coffee.fromEventId == "" || coffee.rescheduled{
                coffee.fromEventId = createEvent(eventStore: eventStore, title: "Coffee with \(coffeeWith)", startDate: startDate, endDate: endDate)
            }
        }
    }
    
    

    
    
    static func addMissingEvents(startDate:Date, beingVisited: String, coffee:Coffee, role: CoffeeRole){
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        let nextDay = startDate.addingTimeInterval(60 * 60 * 2) // 30 mins
        
       
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                
                let predicate = eventStore.predicateForEvents(withStart: startDate, end: nextDay, calendars: calendars)
                var events = eventStore.events(matching: predicate)
                
                for e in events{
                   
                    if e.title.contains("Coffee with \(beingVisited)"){
                        return
                    }
                    
                    else{
                        addEvent(startDate: startDate, coffeeWith: beingVisited, coffee: coffee, role: role)
                    }
                }
            })
        }
        
        else {
            
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: nextDay, calendars: calendars)
            var events = eventStore.events(matching: predicate)
            
            for e in events{
                
                if e.title.contains("Coffee with \(beingVisited)"){
                    return
                }
                    
                else{
                    addEvent(startDate: startDate, coffeeWith: beingVisited, coffee: coffee, role: role)
                }
            }
        }
    }


    
    // Responds to button to remove event. This checks that we have permission first, before removing the
    // event
    static func removeEvent(savedEventId:String) {
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                self.deleteEvent(eventStore: eventStore, eventIdentifier: savedEventId)
            })
        } else {
            deleteEvent(eventStore: eventStore, eventIdentifier: savedEventId)
        }
        
    }
    


    
    
//    static func todaysDate() -> Date{
//        let date = NSDate()
//        let calendar = NSCalendar.current
//        let hour = calendar.component(.hour, from: date as Date)
//        let minutes = calendar.component(.minute, from: date as Date)
//        
//        return
//    }

}
