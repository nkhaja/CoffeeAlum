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
    var userId:String = ""
    var thisUser:User?
    var selectedUser:User?

    var alumni:[User] = []
    var students:[User] = []
    var coffees:[Coffee] = []
    
    var filteredAlumni: [User] = []

    let userRef = FIRDatabase.database().reference(withPath: "users")
    var currentUserRef:FIRDatabaseReference?
    var searchController: UISearchController!
    
    


    
    
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
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            if let user = user{
                self.userId = user.uid
                self.currentUserRef = FIRDatabase.database().reference(withPath: self.userId)
                self.currentUserRef!.observe(.value, with: { snapshot in
                    if snapshot.hasChildren(){
                        self.thisUser = User(snapshot: snapshot)
                        self.thisUser?.uid = self.userId
                        if let tbc = self.tabBarController as? CustomTabBarController {
                            tbc.thisUser = self.thisUser
                            tbc.userRef = self.userRef
                        }
                        
                    }

                })
            }
        }
        
        
//        //let coffeeRef = FIRDatabase.database().reference(withPath: "coffee")
//        var testUser = User(name: "Nabil Khaja", account: .alumni)
//        testUser.interests.append("Jogging")
//        var testEmployer = Employer(name: "Make School", position: "Engineer")
//        let testPicture = UIImage(named: "testUser3")
//        pictureAsString = Helper.imageToDataString(image: testPicture!)
//        
//        
//        testUser.employer = testEmployer
//        testUser.portrait = pictureAsString!
//        
//        
//        currentUserRef!.setValue(testUser.toAnyObject())
//        employerRef.setValue(testUser.employer!.toAnyObject())
        
        
//            currentUserRef!.observe(.value, with: { snapshot in
//            print(snapshot.value)
//            let newStuff = User(snapshot: snapshot)
//            print(newStuff)
//        })
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
                    if a.employer!.name.lowercased().range(of: searchText.lowercased()) != nil{
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

    
//    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
//        try! FIRAuth.auth()?.signOut()
//         self.performSegue(withIdentifier: "logOut", sender: self)
//    }
    
    
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

        
        if filteredAlumni.count > 0{
            return self.filteredAlumni.count
        }
        
        else if searchController.searchBar.text == ""{
            return alumni.count
        }
        
        return 0
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "connect") as! ConnectTableViewCell
        
        let alumForRow = alumni[indexPath.row]
//        cell.nameLabel.text = alumForRow.name
//        cell.employmentLabel.text = alumForRow.employer!.name
//        cell.locationLabel.text = alumForRow.location
        //cell.profileImage.image = Helper.dataStringToImage(dataString: pictureAsString!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = alumni[indexPath.row]
        performSegue(withIdentifier: "seeProfile", sender: self)
        
    }
}

