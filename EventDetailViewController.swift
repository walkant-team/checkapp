//
//  EventDetailViewController.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    

    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var scheduleLabel:UILabel!
    @IBOutlet var addressLabel:UILabel!
    @IBOutlet var descriptionText:UITextView!
    
    var event:Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionText.text = event.description
        scheduleLabel.text = event.schedule
        titleLabel.text = event.title
        addressLabel.text = event.address
        
        // Set the title of the navigation bar
        title = event.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
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
