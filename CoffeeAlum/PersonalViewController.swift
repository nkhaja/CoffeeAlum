//
//  PersonalViewController.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-10.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import UIKit
import Spring

class PersonalViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: DesignableLabel!
    @IBOutlet weak var careerLabel: DesignableLabel!
    @IBOutlet weak var locationLabel: DesignableLabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changePictureButton(_ sender: DesignableButton) {
    }

    @IBOutlet weak var editSummaryButton: DesignableImageView!
    
    
    @IBAction func addItemButton(_ sender: DesignableButton) {
    }

}


extension PersonalViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalCell") as! PersonalTableViewCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
