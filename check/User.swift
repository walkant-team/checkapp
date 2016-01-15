//
//  User.swift
//  check
//
//  Created by angelito on 1/3/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import Foundation

class User {
  
  var id : Int!
  var first_name : String!
  var last_name : String!
  var address : String!
  var email : String!
  var full_name : String!
  
  init(data : NSDictionary){        
    self.id = data["id"] as! Int
    self.first_name = data["first_name"] as! String
    self.last_name = data["last_name"] as! String
    self.email = data["email"] as! String
    self.full_name = "\(self.first_name) \(self.last_name)"
    self.address = data["address"] as! String
  }
}