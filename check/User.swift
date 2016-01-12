//
//  User.swift
//  check
//
//  Created by angelito on 1/3/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import Foundation

class User {
  
  var userId : Int!
  var username : String!
  
  init(data : NSDictionary){
    
    self.userId = data["id"] as! Int
//    self.username = Utils.getStringFromJSON(data, key: "username")
  }
  
}