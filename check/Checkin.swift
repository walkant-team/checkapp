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
    self.hour_in = data["hour_in"] as! String
    self.date_in = data["date_in"] as! String
    self.hour_out = data["hour_out"] as? String
    self.date_out = data["date_out"] as? String
    self.check_out = data["check_out"] as! Bool
    self.fulldate_in = "\(self.hour_in) \(self.date_in)"
    if self.check_out == true {
      self.fulldate_out = "\(self.hour_out) \(self.date_out)"
    }else {
      self.fulldate_out = "No se hizo checkout"
    }
    if let scheduleData = data["schedule"] as? NSDictionary {
      self.schedule = Schedule(data: scheduleData)
    }    
  }
}
