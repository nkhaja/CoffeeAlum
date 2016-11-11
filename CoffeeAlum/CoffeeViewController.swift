//
//  CoffeeViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Firebase
class CoffeeViewController: UIViewController {
    
    var coffeeRef = FIRDatabase.database().reference(withPath: "coffee")
    var userRef = FIRDatabase.database().reference(withPath: "users")
    var thisUser:User?
    var pendingCoffees:[Coffee] = []
    var upcomingCoffees: [Coffee] = []
    var otherUser:User?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController {
            self.thisUser = tbc.thisUser
        }
        
        
        let invitedQuery = coffeeRef.queryOrdered(byChild: "toId").queryEqual(toValue: thisUser!.name)
        let requestQuery = coffeeRef.queryOrdered(byChild: "fromId").queryEqual(toValue: thisUser!.name)
        
        
        invitedQuery.observe(.value, with:{ snapshot in
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
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeCoffee"{
            if let seeCoffeeViewController = segue.destination as? SeeCoffeeViewController{
                // change specific items in the see Coffee ViewController
            }
        }
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
            cell.whenLabel.text = coffee.date.convertToString()
            cell.whereLabel.text = coffee.location
        
            if thisUser!.name == coffee.fromId{
                cell.whoLabel.text = coffee.toId
            }
            else{
                cell.whoLabel.text = coffee.fromId
            }
        }
        
        else{
            let coffee = pendingCoffees[indexPath.row]
            cell.whenLabel.text = coffee.date.convertToString()
            cell.whereLabel.text = coffee.location
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var searchValue:String?
        var coffee:Coffee?
        
        //Determine Section
        if indexPath.section == 0{
             coffee = pendingCoffees[indexPath.row]
        }
        
        else{
             coffee = pendingCoffees[indexPath.row]
        }
        
        //Get role of this user
        if thisUser!.name == coffee!.fromId{
            searchValue = coffee!.toId
        }
        else{
            searchValue = coffee!.fromId
        }
        
        let query = self.userRef.queryOrdered(byChild: "name").queryEqual(toValue: searchValue)
        
        query.observe(.value, with:{ snapshot in
            self.otherUser = User(snapshot: snapshot)
            self.performSegue(withIdentifier: "seeCoffee", sender: self)
        })

    }
}
