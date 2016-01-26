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
  var event: Event!
  var user: User!
  var checkin: Checkin?
  
  init(data : NSDictionary){
    
    self.id = data["id"] as! Int
    self.hour = data["hour"] as! String
    self.date = data["date"] as! String
    
    let dateString = "\(self.date) \(self.hour)"
    let datetime = dateString.toDateTime()    
    self.date_time = datetime?.toStringCustom()
    
    if let eventData = data["event"] as? NSDictionary {
      self.event = Event(data: eventData)
    }
    if let checkinData = data["checkin"] as? NSDictionary {
      self.checkin = Checkin(data: checkinData)
    }
  }
}
