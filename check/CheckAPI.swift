//
//  checkAPI.swift
//  check
//
//  Created by angelito on 12/30/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class CheckAPI {
    
  let base_url = "http://checkin.kodevianapps.com:80/api/v1"
  var jsonArray:NSMutableArray?
  
  var OAuthToken: String? {
    set {
      if let valueToSave = newValue {
        do {
          try Locksmith.updateData(["token": valueToSave], forUserAccount: "checkinApp")
        } catch {
          let _ = try? Locksmith.deleteDataForUserAccount("checkinApp")
        }
      } else { // they set it to nil, so delete it
        let _ = try? Locksmith.deleteDataForUserAccount("checkinApp")
      }
    }
    get {
      // try to load from keychain
      Locksmith.loadDataForUserAccount("checkinApp")
      let dictionary = Locksmith.loadDataForUserAccount("checkinApp")
      if let token =  dictionary?["token"] as? String {
        return token
      }
      return nil
    }
  }
  
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
  
  func logout(completion: (successful: Bool) -> ()) {
    let urlString = base_url + "/logout/"
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      Alamofire.request(.POST, urlString, headers: headers)
        .responseJSON { response in
          self.OAuthToken = nil
          let successful = response.response?.statusCode == 200
          completion(successful: successful)
      }
    }
  }
  
  func hasOAuthToken() -> Bool {
    if let token = self.OAuthToken {
      return !token.isEmpty
    }
    return false
  }
  
  func checkVerified(scheduleId:Int, completion: ((checkin: Checkin?) -> Void)!) {
    let urlString = base_url + "/checkins/\(scheduleId)/verified/"
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      
      Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
        if let JSON = response.result.value {
          if (response.response?.statusCode == 200) {
            let checkin = Checkin(data: JSON as! NSDictionary)
            completion(checkin: checkin)            
          }
        }
      }
    }
  }
  
  func checkinSchedule(scheduleId: Int, completion: (successful: Bool) -> ()) {
    let urlString = "\(base_url)/checkins/"
    if let token = self.OAuthToken {
      let parameters = [
        "schedule": scheduleId
      ]
      
      let headers = [
        "Authorization": "token \(token)"
      ]
      
      Alamofire.request(.POST, urlString, headers: headers, parameters: parameters).validate().responseJSON { response in
        let successful = response.response?.statusCode == 200
        completion(successful: successful)
      }
    }
  }
  
  func checkoutSchedule(checkinId: Int, completion: (successful: Bool) -> ()) {
    let urlString = base_url + "/checkouts/\(checkinId)/retrieve/"
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      
      Alamofire.request(.PUT, urlString, headers: headers).validate().responseJSON { response in
        let successful = response.response?.statusCode == 200
        completion(successful: successful)
      }
    }
  }
  
  func loadSchedules(completion: (([Schedule]) -> Void)!) {
    let urlString = "\(base_url)/schedules/"
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      var schedules = [Schedule]()
      Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
        if let JSON = response.result.value {
          self.jsonArray = JSON["results"] as? NSMutableArray
          for item in self.jsonArray! {
            let schedule = Schedule(data: item as! NSDictionary)
            self.checkVerified(schedule.id) { (checkin) -> Void in
              schedule.checkin = checkin
            }
            schedules.append(schedule)
          }
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
  
  func loadCheckins(completion: (([Checkin]) -> Void)!) {
    let urlString = base_url + "/checkins/"
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      var checkins = [Checkin]()
      Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
        if let JSON = response.result.value {
          self.jsonArray = JSON["results"] as? NSMutableArray
          for item in self.jsonArray! {
            let checkin = Checkin(data: item as! NSDictionary)
            checkins.append(checkin)
          }
          let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
          dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
              completion(checkins)
            }
          }
        }
      }
    }
  }
}