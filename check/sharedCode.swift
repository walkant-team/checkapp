//
//  sharedCode.swift
//  check
//
//  Created by Jorge Crisóstomo Palacios on 1/16/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import Foundation

extension String
{
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = NSDateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        
        //Return Parsed Date
        return dateFromString
    }
}

extension NSDate
{
    func toStringCustom() -> String
    {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "EEEE d' de 'MMM h:mm a"
        dateFormatter.locale = NSLocale(localeIdentifier: "es_PE")
        
        let stringFromDate : String = dateFormatter.stringFromDate(self)
        
        return stringFromDate
    }
}