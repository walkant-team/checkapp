//
//  ViewController.swift
//  check
//
//  Created by angelito on 12/21/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    let MyKeychainWrapper = KeychainWrapper()
    
    let api = CheckAPI()
  
    override func viewDidLoad() {
        
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
        emailLabel.text = storedUsername as String
      }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func signinBtnTapped(sender: AnyObject) {
      
      if (emailLabel.text == "" || passwordLabel.text == "") {
        
        let alertView = UIAlertController(title: "Login Problem",
          message: "Wrong username or password." as String, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
        return;
      }
      
      emailLabel.resignFirstResponder()
      passwordLabel.resignFirstResponder()
      
      api.loginWithEmail(emailLabel.text!, password: passwordLabel.text!) { (token) -> Void in
        if let token = token {
          self.MyKeychainWrapper.mySetObject(token, forKey:kSecValueData)
          self.MyKeychainWrapper.writeToKeychain()
          self.performSegueWithIdentifier("dismissLogin", sender: self)
        } else {
          let alertView = UIAlertController(title: "Login Problem",
            message: "Wrong username or password." as String, preferredStyle:.Alert)
          let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
          alertView.addAction(okAction)
          self.presentViewController(alertView, animated: true, completion: nil)
        }
      }
    }
}

