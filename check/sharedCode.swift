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
  func toDateTime() -> NSDate?
  {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = formatter.dateFromString(self) {
      return date
    } else {
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
      if let  date = formatter.dateFromString(self) {
        return date
      }
    }
    return nil
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