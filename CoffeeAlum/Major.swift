
//  Created by Nabil K on 2016-10-08.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation

struct Major{
    var graduationDate:Date?
    var major:String
    var type: DegreeType
    
    
    func toAnyObject() -> Any{
        return [
            "graduationDate": graduationDate?.convertToString(),
            "major":major,
            "type": type.rawValue,
        ]
    }
    
}


enum DegreeType: String{
    case bachelors = "Bachelors"
    case masters = "Masters"
    case doctorate = "Doctorate"
    case law = "Law"
    case medical = "Medical"
    case dental = "Dental"
}

extension Date{
    func convertToString() -> String{
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
}
