//
//  MenuController.swift
//  check
//
//  Created by angelito on 12/28/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit
import Locksmith
import SWRevealViewController

class MenuController: UITableViewController {
  let api = CheckAPI()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
      self.clearsSelectionOnViewWillAppear = false
      let rowToSelect:NSIndexPath = NSIndexPath(forRow: 1, inSection: 0);  //slecting 0th row with 0th section
      self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
      
      let cell = tableView.cellForRowAtIndexPath(rowToSelect)
      cell?.contentView.backgroundColor = UIColor(red:0.037, green:0.468, blue:0.707, alpha:1.0)
      cell?.contentView.layer.borderWidth = 0.0
      self.tableView.separatorColor = UIColor(red:0.037, green:0.468, blue:0.707, alpha:1.0)
      
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func logout(sender: AnyObject) {
//    self.revealViewController().revealViewController()
//    self.performSegueWithIdentifier("logoutView", sender: self)
//    api.logout() { (successful) -> () in
//      print(successful)
//    }
  }
  
    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.backgroundColor = UIColor.redColor()

        return cell
    }
  
*/
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
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    if indexPath.row != 0 {
      let cell = tableView.cellForRowAtIndexPath(indexPath)
      cell?.contentView.backgroundColor = UIColor(red:0.037, green:0.468, blue:0.707, alpha:1.0)
//    }
    
//    // sign in item
    if indexPath.row == 4 {
      api.logout() { (successful) -> () in
        print(successful)
      }
    }
  }
}
