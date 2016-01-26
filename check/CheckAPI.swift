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
  var next_schedules: String?
  var total_schedules: Int!
  var next_checkins: String?
  var total_checkins: Int!
  
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
        }else{
          return
        }
      }
    }
  }
  
  func checkinSchedule(scheduleId: Int, image : UIImage, completion: (successful: Bool) -> ()) {
    if let _ = self.OAuthToken {
      let image_new : NSData = UIImageJPEGRepresentation(image, 50)!
        
      let parameters = [
        "image": NetData(data: image_new, mimeType: .ImageJpeg, filename: "customName.jpg"),
        "schedule": scheduleId
      ]
      let urlString = self.urlRequestWithComponents("\(base_url)/checkins/", parameters: parameters)
      Alamofire.upload(urlString.0, data: urlString.1)
        .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
          print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
        }
        .responseJSON { response in
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
  
  func loadSchedules(var urlString: String?, completion: (([Schedule]) -> Void)!) {
    if urlString == nil{
      urlString = "\(base_url)/schedules/"
    }
    
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      var schedules = [Schedule]()
      Alamofire.request(.GET, urlString!, headers: headers).responseJSON { response in
        if let JSON = response.result.value {
          self.next_schedules = JSON["next"] as? String
          self.total_schedules = JSON["count"] as! Int
          self.jsonArray = JSON["results"] as? NSMutableArray
          if self.jsonArray != nil {
            for item in self.jsonArray! {
              let schedule = Schedule(data: item as! NSDictionary)
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
  }
  
  func loadCheckins(var urlString: String?, completion: (([Checkin]) -> Void)!) {
    if urlString == nil{
      urlString = "\(base_url)/checkins/"
    }
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      var checkins = [Checkin]()
      Alamofire.request(.GET, urlString!, headers: headers).responseJSON { response in
        if let JSON = response.result.value {
          self.next_checkins = JSON["next"] as? String
          self.total_checkins = JSON["count"] as! Int
          self.jsonArray = JSON["results"] as? NSMutableArray
          if self.jsonArray != nil {
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
  
  func loadProfile(completion: ((user: User?) -> Void)!) {
    let urlString = base_url + "/users/retrieve/"
    
    if let token = self.OAuthToken {
      let headers = [
        "Authorization": "token \(token)"
      ]
      Alamofire.request(.GET, urlString, headers: headers).responseJSON { response in
        if let JSON = response.result.value {
          if (response.response?.statusCode == 200) {
            let user = User(data: JSON as! NSDictionary)
            completion(user: user)
          }
        }
      }
    }
  }
  

  func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
    
    // create url request to send
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
    //let boundaryConstant = "myRandomBoundary12345"
    let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
    let contentType = "multipart/form-data;boundary=" + boundaryConstant
    if let token = self.OAuthToken {
      mutableURLRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
    // create upload data to send
    let uploadData = NSMutableData()
    
    // add parameters
    for (key, value) in parameters {
      
      uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
      
      if value is NetData {
        // add image
        let postData = value as! NetData
        
        //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // append content disposition
        let filenameClause = " filename=\"\(postData.filename)\""
        let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
        let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
        uploadData.appendData(contentDispositionData!)
        
        
        // append content type
        //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
        let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
        let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
        uploadData.appendData(contentTypeData!)
        uploadData.appendData(postData.data)
        
      }else{
        uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
      }
    }
    uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    
    
    
    // return URLRequestConvertible and NSData
    return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
  }
  
  
}