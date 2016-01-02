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
    
    let base_url = "http://checkin.kodevianapps.com:80/api/v1/"
    let MyKeychainWrapper = KeychainWrapper()
    var results:[JSON]? = []
  var accessToken : String? = ""
    
    func makeSignInRequest(userEmail:String, userPassword:String) {
        // Create HTTP request and set request Body
        let parameters = [
            "username": userEmail,
            "password": userPassword
        ]
        
        Alamofire.request(.POST, "\(base_url)login/", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
              debugPrint(response)
              if response.response?.statusCode == 200 {
                self.MyKeychainWrapper.mySetObject(self.accessToken, forKey:kSecValueData)
                self.MyKeychainWrapper.writeToKeychain()
                self.accessToken = self.MyKeychainWrapper.myObjectForKey("v_Data") as? String
              } else {
                debugPrint(response.result.debugDescription)
              }
        }
    }
    
    
    func loadSchedules(){
        let headers = [
            "Authorization": "token \(accessToken)",
            "Accept": "application/json"
        ]
        
        let url = "\(base_url)/schedules"
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                debugPrint(response)
        }
    }
}