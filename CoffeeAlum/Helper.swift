//
//  NabilUtility.swift
//  CoffeeAlum
//
//  Created by Nabil K on 2016-10-12.
//  Copyright © 2016 CoffeeAlum. All rights reserved.
//

import Foundation
import UIKit

class Helper {

 static func imageToDataString(image: UIImage) -> String{
    var data = Data()
    data = UIImageJPEGRepresentation(image, 0.8)!
    let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    return base64String
    }

static func dataStringToImage(dataString: String) -> UIImage {
    let data = Data(base64Encoded: dataString, options: .ignoreUnknownCharacters)
    let image = UIImage(data: data!)
    return image!
    }
    
//    static func todaysDate() -> Date{
//        let date = NSDate()
//        let calendar = NSCalendar.current
//        let hour = calendar.component(.hour, from: date as Date)
//        let minutes = calendar.component(.minute, from: date as Date)
//        
//        return
//    }

}
