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
  let api = CheckAPI()
  var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  var loadingView: UIView = UIView()
  var refresher : UIRefreshControl!
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    // refresh
    refresher = UIRefreshControl()
    refresher.attributedTitle = NSAttributedString(string: "pull to refresh")
    refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(refresher)
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  
    tableView.backgroundColor = UIColor.whiteColor()
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
    
    // Menu toggle
    if self.revealViewController() != nil {
      menuButton.target = self.revealViewController()
      menuButton.action = "revealToggle:"
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
//    schedules = [Schedule]()
//    self.schedules.removeAll()
//    self.showLoginView()
  }

  override func viewWillAppear(animated: Bool) {
    schedules = [Schedule]()
    self.schedules.removeAll()
    self.showLoginView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func showActivityIndicator() {
    dispatch_async(dispatch_get_main_queue()) {
      self.loadingView = UIView()
      self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
      self.loadingView.center = self.view.center
      self.loadingView.backgroundColor = UIColor.grayColor()
      self.loadingView.alpha = 0.7
      self.loadingView.clipsToBounds = true
      self.loadingView.layer.cornerRadius = 10
      
      self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
      self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
      self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
      
      self.loadingView.addSubview(self.spinner)
      self.view.addSubview(self.loadingView)
      self.spinner.startAnimating()
    }
  }
  
  func hideActivityIndicator() {
    dispatch_async(dispatch_get_main_queue()) {
      self.spinner.stopAnimating()
      self.loadingView.removeFromSuperview()
    }
  }

  func didLoadSchedules(schedules: [Schedule]){
    self.schedules = schedules
    self.hideActivityIndicator()
    self.tableView.reloadData()
    self.refresher.endRefreshing()
  }
  
  func loadMoreSchedules() {
    api.loadSchedules(api.next_schedules) { (schedules: [Schedule]) -> Void in
      self.schedules! += schedules
      self.hideActivityIndicator()
      self.tableView.reloadData()
    }
  }

  func showLoginView() {
    if !api.hasOAuthToken() {
      self.performSegueWithIdentifier("loginView", sender: self)
    }else{
      self.showActivityIndicator()
      refresh()
    }
  }
  
  func refresh(){
    api.loadSchedules(nil, completion: didLoadSchedules)
  }
  

  @IBAction func unwindSegue(segue: UIStoryboardSegue) {
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
      cell.scheduleLabel.text = schedule.date_time
      cell.addressLabel.text = schedule.event.address
      cell.titleLabel.text = schedule.event.name
      if schedule.checkin != nil {
        cell.checkImageView.image = UIImage(named: "check.png")
      }else{
        cell.checkImageView.image = UIImage(named: "uncheck.png")
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
