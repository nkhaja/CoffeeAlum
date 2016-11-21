//
//  CoffeeViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Firebase

class CoffeeViewController: UIViewController, ignoreCoffeeDelegate {
    
    var coffeeRef = FIRDatabase.database().reference(withPath: "coffees")
    var userRef = FIRDatabase.database().reference(withPath: "users")
    var thisUser:User?
    var pendingCoffees:[Coffee] = []
    var upcomingCoffees: [Coffee] = []
    var otherUser:User?
    var selectedCoffee: Coffee?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController {
            self.thisUser = tbc.thisUser
        }
        
        
        let invitedQuery = coffeeRef.queryOrdered(byChild: "toId").queryEqual(toValue: thisUser!.uid)
        let requestQuery = coffeeRef.queryOrdered(byChild: "fromId").queryEqual(toValue: thisUser!.uid)
        
        
        invitedQuery.observe(.value, with:{ snapshot in
            for item in snapshot.children{
                let itemSnap = item as! FIRDataSnapshot
                let newCoffee = Coffee(snapshot: itemSnap)
                let formatter = DateFormatter()
                
                
                // Remove expired invitations
                let dateSent = formatter.date(from: newCoffee.dateSent)
                let interval = dateSent!.differenceInDaysWithDate(date: Date())
                
                if newCoffee.date == "TBD" || interval > 14{
                    newCoffee.ref?.removeValue()
                    continue
                }
                
                // Remove a Coffee Appointment who's data has past
                if newCoffee.date != "TBD"{
                   
                    let coffeeDate = formatter.date(from: newCoffee.date)
                    let calendar = Calendar.autoupdatingCurrent
                    if calendar.isDateInYesterday(coffeeDate!) {
                        newCoffee.ref?.removeValue()
                        continue
                    }
                }
                
                // Sort Coffees by pending and confirmed
                if newCoffee.accepted{
                    self.upcomingCoffees.append(newCoffee)
                }
                else{
                    self.pendingCoffees.append(newCoffee)
                }
            }
            self.tableView.reloadData()
        })
        
        
        requestQuery.observe(.value, with:{ snapshot in
            for item in snapshot.children{
                let itemSnap = item as! FIRDataSnapshot
                let newCoffee = Coffee(snapshot: itemSnap)
                if newCoffee.accepted{
                    self.upcomingCoffees.append(newCoffee)
                }
                else{
                    self.pendingCoffees.append(newCoffee)
                }
            }
        self.tableView.reloadData()
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeCoffee"{
            if let seeCoffeeViewController = segue.destination as? SeeCoffeeViewController{
                seeCoffeeViewController.isInvited = self.thisUser!.uid == selectedCoffee!.toId
                seeCoffeeViewController.thisCoffee = selectedCoffee
            }
        }
    }

    // IgnoreCoffeeDelegateFunction - Execute for ignored requests
    // Removes a coffee after its been ignored
    func removeIgnoredCoffee(fromId:String){
        var index = 0
        for c in pendingCoffees{
            if c.fromId == fromId{
                c.ref?.removeValue()
                break
            }
            index += 1
        }
        pendingCoffees.remove(at: index)
        tableView.reloadData()
    }



}

extension CoffeeViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 { return pendingCoffees.count }
        else            { return upcomingCoffees.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffee") as! CoffeeTableViewCell
        
        if indexPath.section == 0 {
            let coffee = pendingCoffees[indexPath.row]
            
            if    coffee.date == "TBD"   { cell.whenLabel.text = "TBD"}
            else                    { cell.whenLabel.text = coffee.date}
            
            
            if coffee.location == "TBD" { cell.whereLabel.text = "TBD"}
            else                        { cell.whereLabel.text = coffee.location}
            
                
                
            if thisUser!.name == coffee.fromName{ cell.whoLabel.text = coffee.toId  }
            else                                { cell.whoLabel.text = coffee.fromId}
        
            
            // TREVIN CHANGE THE COLOR HERE TO SOMETHING SUITABLE FOR UNSEEN NOTIFICATIONS
            if !coffee.viewed{
                cell.backgroundColor = UIColor.green
            }
        
        }
        
        else{

            let coffee = pendingCoffees[indexPath.row]
            if    coffee.date == "TBD"{ cell.whenLabel.text = "TBD"}
            else                      { cell.whenLabel.text = coffee.date}
            
            
            if coffee.location == "TBD" { cell.whereLabel.text = "TBD"}
            else                        { cell.whereLabel.text = coffee.location}
            
            
            
            if thisUser!.name == coffee.fromName{ cell.whoLabel.text = coffee.toName  }
            else                                { cell.whoLabel.text = coffee.fromName}
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var searchValue:String?
        var coffee:Coffee?
        
        //Determine Section
        if indexPath.section == 0 { coffee = pendingCoffees[indexPath.row]}
        
        else                      { coffee = pendingCoffees[indexPath.row]}
        
        //Get role of this user
        
        if thisUser!.name == coffee!.fromName{ searchValue = coffee!.toName   }
        else                                 { searchValue = coffee!.fromName }
        
        let query = self.userRef.queryOrdered(byChild: "name").queryEqual(toValue: searchValue)
        
        query.observe(.value, with:{ snapshot in
            self.otherUser = User(snapshot: snapshot)
            self.selectedCoffee = coffee
            self.performSegue(withIdentifier: "seeCoffee", sender: self)
        })

    }
    
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Pending" }
        else            { return "Upcoming"}
    }
    
    
//     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let vw = UIView()
//        vw.backgroundColor = UIColor.red
//        
//        return vw
//    }
}


extension Date {
    
    func differenceInDaysWithDate(date: Date) -> Int {
        let calendar: Calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: self as Date)
        let date2 = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day, .month, .year], from: date1, to: date2)
       
        return components.day!
    }
    
}
