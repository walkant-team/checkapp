//
//  EventTableViewController.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleTableViewController: UITableViewController {
  @IBOutlet var menuButton:UIBarButtonItem!
  
  var schedules : [Schedule]!
  var isAuthenticated = false
  var didReturnFromBackground = false
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
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
    
      schedules = [Schedule]()
      let api = CheckAPI()
      api.loadSchedules(didLoadSchedules)    
  }
  
  func appWillResignActive(notification : NSNotification) {
    
    view.alpha = 0
    isAuthenticated = false
    didReturnFromBackground = true
  }
  
  func appDidBecomeActive(notification : NSNotification) {
    
    if didReturnFromBackground {
      self.showLoginView()
    }
  }
  
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(false)
    self.showLoginView()
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func didLoadSchedules(schedules: [Schedule]){
    self.schedules = schedules
    self.tableView?.reloadData()
  }

  func showLoginView() {
    if !isAuthenticated {
      self.performSegueWithIdentifier("loginView", sender: self)
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
      cell.scheduleLabel?.text = schedule.date_time
      cell.addressLabel?.text = schedule.event.address
      cell.titleLabel?.text = schedule.event.name
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

}