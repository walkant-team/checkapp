//
//  ViewController.swift
//  check
//
//  Created by angelito on 12/21/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    let api = CheckAPI()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func signinBtnTapped(sender: AnyObject) {
        // resign the keyboard for text fields
        if self.emailLabel.isFirstResponder() {
            self.emailLabel.resignFirstResponder()
        }
        
        if self.passwordLabel.isFirstResponder() {
            self.passwordLabel.resignFirstResponder()
        }
        
        // validate presense of required parameters
        if self.emailLabel.text?.characters.count > 0 && self.passwordLabel.text?.characters.count > 0 {
            api.makeSignInRequest(self.emailLabel.text!, userPassword: self.passwordLabel.text!)
        }
        
    }

}

