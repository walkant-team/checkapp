//
//  Event.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import Foundation

class Event {
    var title = ""
    var schedule = ""
    var address = ""
    init(title:String, schedule:String, address:String){
        self.title = title
        self.schedule = schedule
        self.address = address
    }
}
