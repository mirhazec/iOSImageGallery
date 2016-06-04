//
//  DateUtilities.swift
//  iOSImageGallery
//
//  Created by Mirha Zec on 6/4/16.
//  Copyright © 2016 Mirha Zec. All rights reserved.
//

import Foundation
class DateUtilities{
    
  
    let dateFormatter = NSDateFormatter()

    class var sharedInstance : DateUtilities {
        struct Singleton {
            static let instance : DateUtilities = DateUtilities.init()!
        }
        return Singleton.instance
    }
    
    required init?() {
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
    }
    
    func getTimeLocalized(date:NSDate) ->String {
        
        return dateFormatter.stringFromDate(date)
        
    }

    
}
