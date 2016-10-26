
//  Created by Nabil K on 2016-10-08.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation

struct Education{
    var school: String
    var graduationYear:String
    var major:String
    var type: DegreeType
    
    
    func toAnyObject() -> Any{
        return [
            "school":school,
            "graduationYear": graduationYear,
            "major":major,
            "type": type.rawValue
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
