//
//  HistoricTableViewController.swift
//  check
//
//  Created by angelito on 1/14/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import UIKit

class CheckinTableViewController: UITableViewController {
  
  @IBOutlet weak var menuButton:UIBarButtonItem!
  var checkins : [Checkin]!
  let api = CheckAPI()
  var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  var loadingView: UIView = UIView()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      if revealViewController() != nil {
        menuButton.target = revealViewController()
        menuButton.action = "revealToggle:"
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      }
      
      checkins = [Checkin]()
      self.showActivityIndicator()
      api.loadCheckins(nil, completion: didLoadCheckins)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func didLoadCheckins(checkins: [Checkin]){
    self.checkins = checkins
    self.hideActivityIndicator()
    self.tableView.reloadData()
  }
  
  func loadMoreCheckins() {
    api.loadCheckins(api.next_checkins) { (checkins: [Checkin]) -> Void in
      self.checkins! += checkins
      self.tableView.reloadData()
    }
  }
  
  func showLoginView() {
    if !api.hasOAuthToken() {
      self.performSegueWithIdentifier("loginView", sender: self)
    }
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.checkins?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("checkinCell", forIndexPath: indexPath) as! CheckinTableViewCell
        // Configure the cell...
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      let checkin = checkins[indexPath.row]
      cell.checkinDateLabel?.text = checkin.fulldate_in
      cell.checkoutDateLabel?.text = checkin.fulldate_out
      cell.eventLabel?.text = checkin.schedule.event.name
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == (self.checkins.count - 1) && (self.checkins.count < api.total_checkins){
      self.loadMoreCheckins()
    }
  }
}
