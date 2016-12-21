
//  Created by Nabil K on 2016-10-08.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import Firebase

struct Education{
    
    var school: String
    var graduationYear:String
    var major:String
    var type: DegreeType
    var logo: String = ""
    var key: String = ""
    var ref: FIRDatabaseReference?
    

    init(school: String, graduationYear:String, major:String, type:DegreeType){
        self.school = school
        self.graduationYear = graduationYear
        self.major = major
        self.type = type
    }
    
    init(snapshot:FIRDataSnapshot){
        key = snapshot.key
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String:Any]
        self.school = snapshotValue["school"] as! String
        self.graduationYear = snapshotValue["graduationYear"] as! String
        self.major = snapshotValue["major"] as! String
        self.type = DegreeType(rawValue:snapshotValue["type"] as! String)!
        let logoData = snapshotValue["logo"] as? String
        if logoData != nil{
            self.logo = logoData!
        }
    }
    
    func toAnyObject() -> Any{
        return [
            "school":school,
            "graduationYear": graduationYear,
            "major":major,
            "type": type.rawValue,
            "logo": self.logo
        ]
    }
    
}

enum DegreeType: String{
    case bsc = "BSc"
    case ba = "BA"
    case bba = "BBA"
    case msc = "MSc"
    case ma = "MA"
    case pdh = "PhD"
    case md = "MD"
    case jd = "JD"
    case dds = "DDS"

}

extension Date{
    func convertToString() -> String{
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
}
