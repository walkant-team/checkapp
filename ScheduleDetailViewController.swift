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
    @IBOutlet weak var checkinButton: UIButton!
  
    let checkinButtonTag = 0
    let checkoutButtonTag = 1
  
    let api = CheckAPI()
    var schedule : Schedule!
    var checkin : Checkin?
  
    override func viewDidLoad() {            
      descriptionText.text = schedule.event.description
      scheduleLabel.text = schedule.date_time
      titleLabel.text = schedule.event.name
      addressLabel.text = schedule.event.address
    
      // Set the title of the navigation bar
      title = schedule.event.name
      
      if (self.schedule.checkin == nil) {
        self.checkinButton.setTitle("Checkin", forState: UIControlState.Normal)
        self.checkinButton.tag = self.checkinButtonTag
      } else if (self.schedule.checkin?.check_out == false) {
        self.checkinButton.setTitle("Checkout", forState: UIControlState.Normal)
        self.checkinButton.tag = self.checkoutButtonTag
      }else {
        self.checkinButton.hidden = true
      }
      print("viewDidLoad cell")
      super.viewDidLoad()
    }
  
  func didLoadCheckin(checkin: Checkin?){
    self.schedule.checkin = checkin
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

  @IBAction func checkinAction(sender: AnyObject) {
    if sender.tag == checkinButtonTag {
      api.checkinSchedule(schedule.id) { (successful) -> () in
        self.checkinButton.setTitle("Checkout", forState: UIControlState.Normal)
        self.checkinButton.tag = self.checkoutButtonTag
        print(successful)
      }
    } else if sender.tag == checkoutButtonTag {
      api.checkoutSchedule(schedule.checkin!.id) { (successful) -> () in
        print(successful)
        self.checkinButton.hidden = true
      }
    }    
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
