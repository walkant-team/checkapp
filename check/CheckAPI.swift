//
//  checkAPI.swift
//  check
//
//  Created by angelito on 12/30/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import Foundation
import Alamofire


class CheckAPI {
    
  let base_url = "http://checkin.kodevianapps.com:80/api/v1"
  let MyKeychainWrapper = KeychainWrapper()
  var results:[JSON]? = []
  var jsonArray:NSMutableArray?
  
  func loginWithEmail(email: String, password: String, completion: ((token: String?) -> Void)!) {
    let urlString = base_url + "/login/"
    let parameters = [
      "grant_type": "password",
      "username": email,
      "password": password
    ]
    
    Alamofire.request(.POST, urlString, parameters: parameters)
      .responseJSON { response in
        let token = response.result.value!["token"] as? String
        completion(token: token)
    }
  }

//  func makeSignInRequest(userEmail:String, userPassword:String) {
//    let parameters = [
//      "username": userEmail,
//      "password": userPassword
//    ]
//    Alamofire.request(.POST, "\(base_url)/login/", parameters: parameters).validate().responseJSON { response in
//      if (response.result.value != nil) {
//        switch response.result {
//        case .Success:
//          let token = response.result.value!["token"] as! String
//          self.MyKeychainWrapper.mySetObject(token, forKey:kSecValueData)
//          self.MyKeychainWrapper.writeToKeychain()
//        case .Failure(let error):
//          debugPrint(error)
//        }
//      }
//    }
//  }
  
  func checkVerified(schedule_id:Int, completion: ((checkin: Checkin?) -> Void)!) {
    let urlString = "\(base_url)/checkins/\(schedule_id)/verified/"
    let token = self.MyKeychainWrapper.myObjectForKey("v_Data")
    let headers = [
      "Authorization": "token \(token)"
    ]
    
    Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
      if let JSON = response.result.value {
        if JSON["id"] != nil {
          let checkin = Checkin(data: JSON as! NSDictionary)
          let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
          dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
              completion(checkin: checkin)
            }
          }
        }
      }
    }
  }
  
  func didLoadCheckin(checkin: Checkin!){
    
  }
  
  func loadSchedules(completion: (([Schedule]) -> Void)!) {
    let urlString = "\(base_url)/schedules/"
//    let token = self.MyKeychainWrapper.myObjectForKey("v_Data")
    let token = "51880e877b5cba803f981121e18109a9bbc5d553"
    let headers = [
      "Authorization": "token \(token)"
    ]

    var schedules = [Schedule]()
    
    Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
      if let JSON = response.result.value {        
        self.jsonArray = JSON["results"] as? NSMutableArray
        for item in self.jsonArray! {
          let schedule = Schedule(data: item as! NSDictionary)
          let urlStringCheckin = "\(self.base_url)/checkins/\(schedule.id)/verified/"
          
          Alamofire.request(.GET, urlStringCheckin, headers: headers).responseJSON { response in
            if let checkin_json = response.result.value {
              if checkin_json["id"] != nil {
                schedule.checkin = true
              }
            }
          }
          
//        self.checkVerified(schedule.id, completion: checkin?)
          schedule.checkin = true
          schedules.append(schedule)
        }
        completion(schedules)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
          dispatch_async(dispatch_get_main_queue()) {
            completion(schedules)
          }
        }
      }
    }
   }
}