//
//  Event.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import Foundation

class Event {
    
  var eventId : Int!
  var name : String!
  var address : String!
  var longitude : Double
  var latitude : Double
  var description : String!
  var is_enabled : Bool!
  var file: String?
  
  init(data : NSDictionary){
    self.eventId = data["id"] as! Int
    self.name = data["name"] as! String
    self.address = data["address"] as! String
    self.longitude = Double(data["longitude"] as! String)!
    self.latitude = Double(data["latitude"] as! String)!
    self.description = data["description"] as! String
    self.is_enabled = data["is_enabled"] as! Bool
    self.file = data["file_1"] as? String
  }
}
