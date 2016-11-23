//
//  SeeCoffeeViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-11-09.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//


protocol ignoreCoffeeDelegate {
    func removeIgnoredCoffee(fromId:String)
}

import UIKit
import Spring
import MapKit
import EventKit
import Firebase


// INVARIANT: Only Users that receive invitations can accept and set the time/place
class SeeCoffeeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //Date-Related Outlets
   
    @IBOutlet weak var dateView: DesignableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var whoLabel: DesignableLabel!
    @IBOutlet weak var whenLabel: DesignableLabel!
    @IBOutlet weak var whereLabel: DesignableLabel!
    
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var confirmButton: DesignableButton!
    @IBOutlet weak var rescheduleButton: DesignableButton!
    @IBOutlet weak var setDateButton: DesignableButton!
    
    var userBeingVisited: User?
    var thisCoffee: Coffee?
    var isInvited: Bool = false
    var startDate: Date?
    
    var locationSet: Bool = false
    var dateSet: Bool = false
    var delegate: ignoreCoffeeDelegate?
    
    //For location based functions in MapKit
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    // For events:
    let eventStore = EKEventStore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().persistenceEnabled = true
        
        whoLabel.text = userBeingVisited?.name
        self.dateView.isHidden = true
        
        // Convert Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm Z"
        startDate = Helper.stringToDate(date: thisCoffee!.date)

        
        
        if !self.isInvited{
            confirmButton.isHidden = true
            ignoreButton.isHidden = true
            rescheduleButton.isHidden = true
            setDateButton.isHidden = true
            
            if thisCoffee?.toEventId != "" && thisCoffee?.fromEventId == ""{
                Helper.addEvent(startDate: startDate!, coffeeWith: userBeingVisited!.name, coffee: thisCoffee!, role: .from)
                thisCoffee!.ref!.child("fromEventId").setValue(thisCoffee!.fromEventId)
            }
            
            else if thisCoffee!.toEventId != "" && thisCoffee!.rescheduled{
                thisCoffee!.rescheduled = false
                Helper.removeEvent(savedEventId: thisCoffee!.fromEventId)
                Helper.addEvent(startDate: startDate!, coffeeWith: userBeingVisited!.name, coffee: thisCoffee!, role: .from)
                thisCoffee!.ref!.child("fromEventId").setValue(thisCoffee!.fromEventId)
            }
        
        }
        
        else if thisCoffee!.accepted{
            confirmButton.setTitle("Cancel", for: UIControlState.normal)
            confirmButton.isHidden = true
            ignoreButton.isHidden = true
            rescheduleButton.isHidden = false
        }
        
        
        


        
        //Location Setup:
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }

    
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    func setLocation(){
        locationSet = true
        thisCoffee!.location = selectedPin!.title! + "," + selectedPin!.subtitle!
        whereLabel.text = thisCoffee!.location
        mapView.reloadInputViews()
    }
    
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeCoffeeMember" {
            if let profileViewController = segue.destination as? ProfileViewController{
                profileViewController.profileUser = userBeingVisited
                profileViewController.cameFromCoffee = true
            }
        }
    }

    

    @IBAction func profileButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "seeCoffeeMember", sender: self)
    }
    
    @IBAction func confirmButton(_ sender: AnyObject) {
        if locationSet && dateSet{
            
            thisCoffee?.accepted = true
            thisCoffee?.ref?.setValue(thisCoffee?.toAnyObject())
            
            if isInvited{
                if thisCoffee!.toEventId != ""{
                    Helper.removeEvent(savedEventId: thisCoffee!.toEventId)
                    thisCoffee?.rescheduled = true
            }
                Helper.addEvent(startDate: startDate!, coffeeWith: userBeingVisited!.name, coffee: thisCoffee!, role: .to)

            }
        

            let confirmAlert = UIAlertController(title: "Coffee Confirmed!",
                                                 message: "You'll be grabbing Coffee with \(userBeingVisited?.name) at \(thisCoffee?.location)",
                                                 preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok",
                                         style: .default)
            
            confirmAlert.addAction(okAction)
            present(confirmAlert, animated: true, completion: nil)
        }
        
        else{
            
            let setFieldsAlert = UIAlertController(title: "Info Missing", message: "Please set a date and location for this meeting before confirming", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok",
                                         style: .default)
            
            setFieldsAlert.addAction(okAction)
            present(setFieldsAlert, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func rescheduleButton(_ sender: AnyObject) {
        locationSet = false
        dateSet = false
        rescheduleButton.isHidden = true
        confirmButton.isHidden = false
        self.whenLabel.text! = "TBD"
        self.whereLabel.text! = "TBD"
        mapView.reloadInputViews()
    }
    

    @IBAction func ignoreButton(_ sender: AnyObject) {
        let ignoreAlert = UIAlertController(title: "Ignore", message: "Are you sure you want to ignore Coffee request from \(userBeingVisited?.name)?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ignore", style: .default) { action in
            self.delegate?.removeIgnoredCoffee(fromId: self.thisCoffee!.fromId)
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
        
        ignoreAlert.addAction(okAction)
        ignoreAlert.addAction(cancelAction)
        
        present(ignoreAlert, animated: true, completion: nil)
    }
    
    @IBAction func setDateButton(_ sender: AnyObject) {
        self.dateView.isHidden = false
    }
    
    @IBAction func dateSelectedButton(_ sender: AnyObject) {
        if datePicker.date.convertToString().contains("nil"){
            return
        }
            
        else {
            self.dateSet = true
            self.dateView.isHidden = true
            self.thisCoffee!.date = datePicker.date.convertToString()
            self.whenLabel.text! = thisCoffee!.date
        }
    }
    
    @IBAction func cancelDateSelectionButton(_ sender: AnyObject) {
        self.dateView.isHidden = true
    }
    
}



extension SeeCoffeeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: (location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}



extension SeeCoffeeViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        // Set up selected pin for map
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        
        //Drive Callout Button
        let driveButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        
        driveButton.setBackgroundImage(UIImage(named: "car"), for: .normal)
        driveButton.addTarget(self, action: "getDirections", for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = driveButton
        
        //Set Meeting Location Button
        let setLocationButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        setLocationButton.setBackgroundImage(UIImage(named: "car"), for: .normal)
        setLocationButton.addTarget(self, action: "setLocation", for: .touchUpInside)
        
        if !locationSet{
            pinView?.rightCalloutAccessoryView = setLocationButton
        }
        
        
        return pinView
    }
}


