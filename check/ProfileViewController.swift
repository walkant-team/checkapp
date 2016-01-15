//
//  ProfileViewController.swift
//  check
//
//  Created by angelito on 12/28/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  @IBOutlet weak var menuButton:UIBarButtonItem!
  @IBOutlet weak var fullnameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  
    let api = CheckAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
      api.loadProfile { (user) -> Void in
        self.fullnameLabel.text = user?.full_name
        self.emailLabel.text = user?.email
        self.addressLabel.text = user?.address
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
