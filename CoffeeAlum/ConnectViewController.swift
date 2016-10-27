//
//  FirstViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Firebase


class ConnectViewController: UIViewController, UISearchResultsUpdating {
    var userId:String = (FIRAuth.auth()?.currentUser?.uid)!
    var thisUser:User?
    var selectedUser:User?

    var alumni:[User] = []
    var students:[User] = []
    var coffees:[Coffee] = []
    
    var filteredAlumni: [User] = []

    let userRef = FIRDatabase.database().reference(withPath: "users")
    var currentUserRef:FIRDatabaseReference?
    var searchController: UISearchController!
    var updateComplete:Bool = false
    
    


    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater  = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Name", "Employer", "Location", "Interests"]
        searchController.searchBar.showsScopeBar = true
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    
        

        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            if let user = user{
                self.currentUserRef = self.userRef.child(self.userId)
                self.currentUserRef!.observe(.value, with: { snapshot in
                    if snapshot.hasChildren(){
                        self.thisUser = User(snapshot: snapshot)
                        self.thisUser?.uid = self.userId
                        self.updateTable()
                        
                        if let tbc = self.tabBarController as? CustomTabBarController {
                            tbc.thisUser = self.thisUser
                            tbc.userRef = self.userRef
                            self.currentUserRef!.updateChildValues(["uid": user.uid])
                           
                        }
                        
                    }

                })
            }
        }
    }
    
    func updateTable(){
        updateComplete = true
        self.userRef.observe(.value, with:{ snapshot in
            for item in snapshot.children{
                let info = item as! FIRDataSnapshot
                let dict = info.value as! [String:Any]
                let accountType = (dict["account"] as! String)
                if accountType == "alumni"{
                    let alumUser = User(snapshot: info)
                    self.alumni.append(alumUser)
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredAlumni = []
        if let searchText = searchController.searchBar.text{
            filterContent(searchText: searchText, scope: searchController.searchBar.selectedScopeButtonIndex)
            tableView.reloadData()
        }
    }
    
    
        func filterContent(searchText:String, scope: Int){
            filteredAlumni = []
            if alumni.count == 0 {
                return
            }
    
            for a in alumni{
    
                switch(scope){
                case(0):
                    if a.name.lowercased().range(of: searchText.lowercased()) != nil{
                        filteredAlumni.append(a)
                    }
                case(1):
                    if a.employer[0].name.lowercased().range(of: searchText.lowercased()) != nil{
                        filteredAlumni.append(a)
                    }
                case(2):
                    if a.location.lowercased().range(of: searchText.lowercased()) != nil{
                        filteredAlumni.append(a)
                    }
    
                case(3):
                    for i in a.interests{
                        if i.lowercased().range(of: searchText.lowercased()) != nil{
                            filteredAlumni.append(a)
                        }
                    }
                default:
                    break
                }
      
            }
        }

    
    
    @IBAction func logOutButton(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "logOut", sender: self)
    }
  

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeProfile"{
            if let profileViewController = segue.destination as? ProfileViewController{
                // Assigning the user variable to the thisUser variable.
               profileViewController.user = self.selectedUser
                //pass data related to selected profile
            }
        }
    
    }
    
  
}







extension ConnectViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if updateComplete {
            
        
        
            if filteredAlumni.count > 0{
                return self.filteredAlumni.count
            }
            
            else if searchController.searchBar.text == ""{
                return alumni.count
            }
        }
        
        return 0
            
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "connect") as! ConnectTableViewCell
        if updateComplete{
            let alumForRow = alumni[indexPath.row]
            cell.nameLabel.text = alumForRow.name
//            cell.employmentLabel.text = alumForRow.employer[0].name
//            cell.locationLabel.text = alumForRow.location
//            cell.profileImage.image = Helper.dataStringToImage(dataString: alumForRow.portrait)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = alumni[indexPath.row]
        if updateComplete{
            performSegue(withIdentifier: "seeProfile", sender: self)
        }
        
    }
}

