//
//  EventDetailViewController.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class ScheduleDetailViewController: UIViewController, UIDocumentInteractionControllerDelegate {

  @IBOutlet var titleLabel:UILabel!
  @IBOutlet var scheduleLabel:UILabel!
  @IBOutlet var addressLabel:UILabel!
  @IBOutlet var descriptionText:UITextView!
  @IBOutlet weak var checkinButton: UIButton!
  @IBOutlet weak var fileButton: UIButton!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var containerView: UIView!
  
  let checkinButtonTag = 0
  let checkoutButtonTag = 1
  
  let documentInteractionController = UIDocumentInteractionController()
  var finalPath: NSURL?

  let api = CheckAPI()
  var schedule : Schedule!
  var checkin : Checkin?
  
  override func viewDidLoad() {
    descriptionText.text = schedule.event.description
    scheduleLabel.text = schedule.date_time
    titleLabel.text = schedule.event.name
    addressLabel.text = schedule.event.address
    
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
    self.containerView.layer.cornerRadius = 5.0
    self.containerView.clipsToBounds = true
  
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
      
    if (self.schedule.event.file == nil) {
      fileButton.hidden = true
    }
      

    super.viewDidLoad()
      
      let latitude = schedule.event.latitude
      let longitude = schedule.event.longitude
      
      let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 14)
      self.mapView.camera = camera
      
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2DMake(latitude, longitude)
      marker.title = schedule.event.name
      marker.snippet = schedule.event.description
      marker.map = mapView
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
        
//        let carBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        carBtn.setImage(UIImage(named: "car"), forState: UIControlState.Normal)
////        carBtn.addTarget(self.navigationController, action: "", forControlEvents:  UIControlEvents.TouchUpInside)
//        let item = UIBarButtonItem(customView: carBtn)
//        self.navigationItem.rightBarButtonItem = item
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
    
    @IBAction func fileButtonAction(sender: AnyObject) {
        let file_url = self.schedule.event.file! as String
        Alamofire.download(.GET, file_url) { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            
            self.finalPath = directoryURL.URLByAppendingPathComponent(pathComponent!)
            
            if NSFileManager.defaultManager().fileExistsAtPath(self.finalPath!.path!) {
                try! NSFileManager.defaultManager().removeItemAtURL(self.finalPath!)
            }
            
            return self.finalPath!
        }
        .response { _, _, _, error in
            if let error = error {
                print("Failed with error: \(error)")
            } else {
                print("Downloaded file successfully")
                if (self.finalPath != nil){
                    self.documentInteractionController.URL = self.finalPath
                    self.documentInteractionController.delegate = self
                    self.documentInteractionController.presentPreviewAnimated(true)
                }
            }
        }

    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMap" {
            let destinationController = segue.destinationViewController as! MapViewController
            destinationController.event = schedule.event
        }
    }

}
