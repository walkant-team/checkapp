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

class ScheduleDetailViewController: UIViewController, UIDocumentInteractionControllerDelegate, GMSMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet var titleLabel:UILabel!
  @IBOutlet var scheduleLabel:UILabel!
  @IBOutlet var addressLabel:UILabel!
  @IBOutlet var descriptionText:UITextView!
  @IBOutlet weak var checkinButton: UIButton!
  @IBOutlet weak var fileButton: UIButton!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var containerView: UIView!
  var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  var loadingView: UIView = UIView()
  
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
//      var verticalSpace = NSLayoutConstraint(item: self.imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.button, attribute: .Bottom, multiplier: 1, constant: 50)      
    }
    
      self.loadMap()
      super.viewDidLoad()
  }
  
  func loadMap(){
    let latitude = schedule.event.latitude
    let longitude = schedule.event.longitude
    
    let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 14)
    self.mapView.camera = camera
    self.mapView.delegate = self
    
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2DMake(latitude, longitude)
    marker.title = schedule.event.name
    marker.snippet = schedule.event.description
    marker.map = mapView
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

  @IBAction func checkinAction(sender: AnyObject) {
    if sender.tag == checkinButtonTag {
      let image = UIImagePickerController()
      image.delegate = self
//      image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//      image.allowsEditing = false
      image.sourceType = UIImagePickerControllerSourceType.Camera
//      image.cameraDevice = UIImagePickerControllerCameraDevice.Front
      image.allowsEditing = true
      self.presentViewController(image, animated: true, completion: nil)
    } else if sender.tag == checkoutButtonTag {
      api.checkoutSchedule(schedule.checkin!.id) { (successful) -> () in
        print(successful)
        self.checkinButton.hidden = true
      }
    }
  }
  
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    self.dismissViewControllerAnimated(true, completion: nil)
//    pickedImage.image = self.RBSquareImageTo(image)
    
    
    api.checkinSchedule(schedule.id, image: image) { (successful) -> () in
      self.checkinButton.setTitle("Checkout", forState: UIControlState.Normal)
      self.checkinButton.tag = self.checkoutButtonTag
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
    
    
    // GMSMapView delegate
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.performSegueWithIdentifier("showMap", sender: self)
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

}
