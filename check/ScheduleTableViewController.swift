//
//  EventTableViewController.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController

class ScheduleTableViewController: UITableViewController {
  @IBOutlet var menuButton:UIBarButtonItem!
  
  var schedules : [Schedule]!
  var isAuthenticated = false
  var didReturnFromBackground = false
  let api = CheckAPI()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Remove the title of the back button
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  
    // Change the color of the table view
    tableView.backgroundColor = UIColor.whiteColor()
    // Remove the separators of the empty rows
    tableView.tableFooterView = UIView(frame: CGRectZero)
    // Change the color of the separator
    tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
    
    // Menu toggle
    if self.revealViewController() != nil {
      menuButton.target = self.revealViewController()
      menuButton.action = "revealToggle:"
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    print("viewDidLoad table")
//    schedules = [Schedule]()
//    api.loadSchedules(self.didLoadSchedules)
//    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//      self.api.loadSchedules(self.didLoadSchedules)
//    })
  }
  
  override func viewWillAppear(animated: Bool) {
    schedules = [Schedule]()
    self.schedules.removeAll()
    api.loadSchedules(nil, completion: self.didLoadSchedules)
    print("viewWillAppear table")
    print("token: \(api.OAuthToken)")
//    super.viewDidAppear(animated)
//    schedules = [Schedule]()
//    super.viewDidAppear(false)
    self.showLoginView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func checkinSchedules(){
    var new_schedules = [Schedule]()
    for schedule in self.schedules {
      api.checkVerified(schedule.id, completion: { (checkin) -> Void in
        schedule.checkin = checkin
      })
      new_schedules.append(schedule)
    }
    self.schedules.removeAll()
    self.schedules = new_schedules
  }

  func didLoadSchedules(schedules: [Schedule]){
//    var new_schedules = [Schedule]()
//    for schedule in self.schedules {
//      
//      api.checkVerified(schedule.id, completion: { (checkin) -> Void in
//        
//        schedule.checkin = checkin
//      })
//      new_schedules.append(schedule)
//      
//    }
    self.schedules = schedules
    self.tableView.reloadData()
  }
  
  func loadMoreSchedules() {
    api.loadSchedules(api.next_schedules) { (schedules: [Schedule]) -> Void in
      self.schedules! += schedules
      self.tableView?.reloadData()
    }
  }

  func showLoginView() {
    if !api.hasOAuthToken() {
      self.performSegueWithIdentifier("loginView", sender: self)
    }else{
      api.loadSchedules(nil, completion: didLoadSchedules)
      self.tableView?.reloadData()
    }
  }
  
  func appWillResignActive(notification : NSNotification) {
    print("appWillResignActive")
    view.alpha = 0
    isAuthenticated = false
    didReturnFromBackground = true
  }
  
  func appDidBecomeActive(notification : NSNotification) {
    print("appDidBecomeActive")
    if didReturnFromBackground {
      self.showLoginView()
    }
  }

  @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    isAuthenticated = true
    view.alpha = 1.0
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return self.schedules?.count ?? 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("scheduleCell", forIndexPath: indexPath) as! ScheduleTableViewCell

      // Configure the cell...
      let schedule = schedules[indexPath.row]
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      cell.scheduleLabel?.text = schedule.date_time
      cell.addressLabel?.text = schedule.event.address
      cell.titleLabel?.text = schedule.event.name
      if schedule.checkin != nil {
        cell.checkImageView?.image = UIImage(named: "check.png")
      }
      return cell
  }

  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
          // Delete the row from the data source
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return false if you do not want the item to be re-orderable.
      return true
  }
  */

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
      if segue.identifier == "showEventDetail" {
          if let indexPath = tableView.indexPathForSelectedRow {
              let destinationController = segue.destinationViewController as! ScheduleDetailViewController
              destinationController.schedule = schedules[indexPath.row]
          }
      }
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == (self.schedules.count - 1) && (self.schedules.count < api.total_schedules){
      self.loadMoreSchedules()
    }
  }

}
