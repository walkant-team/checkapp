//
//  ViewController.swift
//  check
//
//  Created by angelito on 12/21/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    let api = CheckAPI()
  
    override func viewDidLoad() {
        
      super.viewDidLoad()
      emailLabel.attributedPlaceholder = NSAttributedString(string:"Usuario",
      attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
      passwordLabel.attributedPlaceholder = NSAttributedString(string:"Password",
        attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // hidden keyboard
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    passwordLabel.resignFirstResponder()
    return true
  }
  
  
    @IBAction func signinBtnTapped(sender: AnyObject) {
      
      if (emailLabel.text == "" || passwordLabel.text == "") {
        
        let alertView = UIAlertController(title: "Login Problem",
          message: "Wrong username or password." as String, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Failed Again!", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
        return;
      }
      
      emailLabel.resignFirstResponder()
      passwordLabel.resignFirstResponder()
      
      api.loginWithEmail(emailLabel.text!, password: passwordLabel.text!) { (token) -> Void in
        if let token = token {
          self.api.OAuthToken = token
          self.performSegueWithIdentifier("dismissLogin", sender: self)
        } else {
          let alertView = UIAlertController(title: "Login Problem",
            message: "Wrong username or password." as String, preferredStyle:.Alert)
          let okAction = UIAlertAction(title: "Failed Again!", style: .Default, handler: nil)
          alertView.addAction(okAction)
          self.presentViewController(alertView, animated: true, completion: nil)
        }        
      }
    }
}

