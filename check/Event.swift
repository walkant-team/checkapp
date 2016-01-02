//
//  Event.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import Foundation

class Event {
    
    var id : Int!
    var title : String!
    var schedule : String!
    var address : String!
    var description : String!
    
    init(title:String, schedule:String, address:String, description:String){
        self.title = title
        self.schedule = schedule
        self.address = address
        self.description = description
    }
}
