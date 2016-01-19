//
//  Checkin.swift
//  check
//
//  Created by angelito on 1/7/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import Foundation

class Checkin {
  
  var id : Int!
  var hour_in : String!
  var date_in : String!
  var fulldate_in : String!
  var hour_out : String!
  var date_out : String!
  var fulldate_out : String!
  var check_out : Bool!
  var schedule: Schedule!
  
  init(data : NSDictionary){
    self.id = data["id"] as! Int
    self.check_out = data["check_out"] as! Bool
    
    self.hour_in = data["hour_in"] as! String
    self.date_in = data["date_in"] as! String
    let dateStringIn = "\(self.date_in) \(self.hour_in)"
    let datetimein = dateStringIn.toDateTime()
    self.fulldate_in = datetimein?.toStringCustom()
    
    if self.check_out == true {
      self.hour_out = data["hour_out"] as! String
      self.date_out = data["date_out"] as! String
      let dateStringOut = "\(self.date_out) \(self.hour_out)"
      let datetimeout = dateStringOut.toDateTime()
      self.fulldate_out = datetimeout?.toStringCustom()
    }else {
      self.fulldate_out = "No se hizo checkout"
    }
    if let scheduleData = data["schedule"] as? NSDictionary {
      self.schedule = Schedule(data: scheduleData)
    }    
  }
}
