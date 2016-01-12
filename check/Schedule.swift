//
//  Schedule.swift
//  check
//
//  Created by angelito on 1/3/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import Foundation

class Schedule {
  
  var id : Int!
  var hour : String!
  var date : String!
  var date_time : String!
  var checkin : Bool?
  var checkout : Bool?
  var event: Event!
  var user: User!
  
  
  init(data : NSDictionary){
    
    self.id = data["id"] as! Int
    self.hour = data["hour"] as! String
    self.date = data["date"] as! String
    self.date_time = "\(self.date) \(self.hour)"
    
    if let userData = data["user"] as? NSDictionary {
      self.user = User(data: userData)
    }
    
    if let eventData = data["event"] as? NSDictionary {
      self.event = Event(data: eventData)
    }
  }
}
