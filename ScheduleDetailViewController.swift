//
//  EventDetailViewController.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController {    

    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var scheduleLabel:UILabel!
    @IBOutlet var addressLabel:UILabel!
    @IBOutlet var descriptionText:UITextView!
    
    var schedule:Schedule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionText.text = schedule.event.description
        scheduleLabel.text = schedule.date_time
        titleLabel.text = schedule.event.name
        addressLabel.text = schedule.event.address
      
        // Set the title of the navigation bar
        title = schedule.event.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let carBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        carBtn.setImage(UIImage(named: "car"), forState: UIControlState.Normal)
//        carBtn.addTarget(self.navigationController, action: "", forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: carBtn)
        self.navigationItem.rightBarButtonItem = item
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
