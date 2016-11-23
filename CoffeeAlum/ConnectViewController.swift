//
//  FirstViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-06.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Firebase
import Spring

class ConnectViewController: UIViewController, UISearchResultsUpdating , UISearchBarDelegate{
    var userId:String = (FIRAuth.auth()?.currentUser?.uid)!
    var thisUser:User?
    var selectedUser:User?

    var alumni:[User] = []
    var students:[User] = []
    var coffees:[Coffee] = []
    var filteredUsers: [User] = []
    var showStudents: Bool = false

    let userRef = FIRDatabase.database().reference(withPath: "users")
    var currentUserRef:FIRDatabaseReference?
    var searchController: UISearchController!
    var updateComplete:Bool = false
    var firstLoad = true
    var tableIndex: Int = 2
    
    
    @IBOutlet weak var userTypeLabel: DesignableLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        updateTable()
        userSwitch.addTarget(self, action: "userSwitchTriggered", for: UIControlEvents.valueChanged)
        
        //Firebase Setup
        userRef.keepSynced(true)
        
        
        //SearchController Setup
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater  = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Name", "Employer", "Location", "Interests", "Major"]
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
                        
                        if let tbc = self.tabBarController as? CustomTabBarController {
                            self.currentUserRef!.updateChildValues(["uid": user.uid])
                            tbc.thisUser = self.thisUser
                            tbc.thisUserRef = self.currentUserRef
                        }
                    }
                })
            }
        }
        
        
    }
    
//    Keep table updated on every new visit 
    override func viewDidAppear(_ animated: Bool) {
        if firstLoad{
            firstLoad = false
        }
        
        else{
           updateTable()
        }
    }
    
    func updateTable(){
        updateComplete = true
        self.alumni = []
        self.students = []
        self.filteredUsers = []
        self.userRef.observe(.value, with:{ snapshot in
            for item in snapshot.children{
                let info = item as! FIRDataSnapshot
                let dict = info.value as! [String:Any]
                let accountType = (dict["account"] as! String)
                if self.showStudents{
                    if accountType == "student"{
                    let studentUser = User(snapshot: info)
                        self.students.append(studentUser)
                    }
                }
                else{
                    if accountType == "alumni"{
                        let alumUser = User(snapshot: info)
                        self.alumni.append(alumUser)
                    }
                }
            }
            
        self.tableView.reloadData()
        })
    }
    
    func updateTableForRange(index: Int){
        if index % 15 == 0 && index > 15{
            
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        //filteredAlumni = []
        filteredUsers = []
        if let searchText = searchController.searchBar.text{
            var scope:Int?
            if showStudents{ scope = 4 }
            else{ scope = searchController.searchBar.selectedScopeButtonIndex}
            
            filterFirebaseContent(searchText: searchText, scope: scope!)
        }
    }
    
    
        func filterContent(searchText:String, scope: Int){
            filteredUsers = []
            var arrayToUse: [User] = []
            if alumni.count == 0 {
                return
            }
            
            if showStudents{
                // Not ideal, passing by value duplicates data...
                arrayToUse = self.students
            }
            else{
                arrayToUse = self.alumni
            }
            
    
            for a in arrayToUse{
    
                switch(scope){
                case(0):
                    if a.name.lowercased().range(of: searchText.lowercased()) != nil{
                        filteredUsers.append(a)
                    }
                case(1):
                    if a.employer[0].name.lowercased().range(of: searchText.lowercased()) != nil{
                        filteredUsers.append(a)
                    }
                case(2):
                    if a.location.lowercased().range(of: searchText.lowercased()) != nil{
                        filteredUsers.append(a)
                    }
    
                case(3):
                    for i in a.interests{
                        if i.name.lowercased().range(of: searchText.lowercased()) != nil{
                            filteredUsers.append(a)
                        }
                    }
                default:
                    break
                }
      
            }
            self.tableView.reloadData()
    }
    
    
    func filterFirebaseContent(searchText:String, scope: Int){
        
        filteredUsers = []
        var arrayToUse: [User] = []
        if alumni.count == 0 {
            return
        }
        
        if showStudents{
            // Not ideal, passing by value duplicates data...
            arrayToUse = self.students
        }
        else{
            arrayToUse = self.alumni
        }
        
        
        switch(scope){
        case(0):
            let userNameRef = userRef.queryOrdered(byChild: "name").queryEqual(toValue: searchText)
            //let userNameRef = userRef.queryOrdered(byChild: "name").queryStarting(atValue:)
            userRef.observe(.value, with: { snapshot in
                if snapshot.hasChildren(){
                    for item in snapshot.children{
                        let info = item as? FIRDataSnapshot
                        let searchedUser = User(snapshot: info!)
                        if searchedUser.name.lowercased().range(of: searchText.lowercased()) != nil {
                            self.filteredUsers.append(searchedUser)
                        }
                    }
                }
                self.tableView.reloadData()
            })
            
            
        case(1):
            userRef.observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
                for item in snapshot.children{
                    let info = item as! FIRDataSnapshot
                    let searchedUser = User(snapshot: info)
                    for e in searchedUser.employer{
                        if e.name.lowercased().range(of: searchText.lowercased()) != nil{
                            self.filteredUsers.append(searchedUser)
                            
                        }
                    }
                }
                self.tableView.reloadData()

            }
        case(2):
            //let locationRef = userRef.queryOrdered(byChild: "location").queryStarting(atValue: searchText)
            userRef.observe(.value, with: { snapshot in
                if snapshot.hasChildren(){
                    for item in snapshot.children{
                        let info = item as? FIRDataSnapshot
                        let searchedUser = User(snapshot: info!)
                        if searchedUser.name.lowercased().range(of: searchText.lowercased()) != nil{
                            self.filteredUsers.append(searchedUser)
                        }
                        
                    }
                }
                self.tableView.reloadData()
            })
            
        case(3):
            userRef.observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
                for item in snapshot.children{
                    let info = item as! FIRDataSnapshot
                    let searchedUser = User(snapshot: info)
                    for i in searchedUser.interests{
                        if i.name.lowercased().range(of: searchText.lowercased()) != nil{
                            self.filteredUsers.append(searchedUser)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        
        case(4):
            userRef.observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
                for item in snapshot.children{
                    let info = item as! FIRDataSnapshot
                    let searchedUser = User(snapshot: info)
                    for e in searchedUser.education{
                        if e.major.lowercased().range(of: searchText.lowercased()) != nil{
                            self.filteredUsers.append(searchedUser)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        default:
            break
        }
        
        //self.tableView.reloadData()
    }
    

    
    func userSwitchTriggered(){
        self.showStudents = self.userSwitch.isOn
        if showStudents{
            self.userTypeLabel.text! = "Students"
        }
        else{
            self.userTypeLabel.text! = "Alumni"
        }
        updateTable()
        
    }
    

    @IBAction func logOutButton(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "logOut", sender: self)
    }
  


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeProfile"{
            if let profileViewController = segue.destination as? ProfileViewController{
               profileViewController.profileUser = self.selectedUser
            }
        }
    
    }
}






extension ConnectViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if updateComplete {

            if filteredUsers.count > 0 {
                return self.filteredUsers.count
            }
            
            else if searchController.searchBar.text == ""{
                if showStudents{
                    return students.count
                }
                else{
                    return alumni.count
                }
            }
        }
        
        return 0
            
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "connect") as! ConnectTableViewCell
        var arrayToUse: [User] = []
        if updateComplete{
            if filteredUsers.count > 0 {
                let alumForRow = filteredUsers[indexPath.row]
                cell.nameLabel.text = alumForRow.name
                
                cell.locationLabel.text = alumForRow.location
                cell.schoolLabel.text = alumForRow.education[0].major
                cell.profileImage.image = Helper.dataStringToImage(dataString: alumForRow.portrait)
                
                if alumForRow.employer.count > 0{
                    cell.employmentLabel.text = alumForRow.employer[0].name
                }
                
            }
            else{
                if showStudents{
                    // Not ideal, passing by value duplicates data...
                    arrayToUse = self.students
                }
                else{
                    arrayToUse = self.alumni
                }
                
                let alumForRow = arrayToUse[indexPath.row]
                cell.nameLabel.text = alumForRow.name
                cell.employmentLabel.text = alumForRow.employer[0].name
                cell.locationLabel.text = alumForRow.location
                cell.schoolLabel.text = alumForRow.education[0].school
                cell.profileImage.image = Helper.dataStringToImage(dataString: alumForRow.portrait)
                
                //Refactor to avoid asking twice
                if showStudents{
                    cell.employmentLabel.text = alumForRow.education[0].major
                }
            }

        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredUsers.count > 0 {
            selectedUser = filteredUsers[indexPath.row]
        }
        else{
            selectedUser = alumni[indexPath.row]
        }
        
        
        if updateComplete{
            performSegue(withIdentifier: "seeProfile", sender: self)
        }
        
    }
}

