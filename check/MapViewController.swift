//
//  MapViewController.swift
//  check
//
//  Created by Jorge Crisóstomo Palacios on 1/15/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var event: Event!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude = event.latitude
        let longitude = event.longitude
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 14)
        self.mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = event.name
        marker.snippet = event.description
        marker.map = mapView

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sharedUbication(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let googleAction = UIAlertAction(title: "Google", style: .Default, handler: googleHandler)
        let wazeAction = UIAlertAction(title: "Waze", style: .Default, handler: wazeHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        actionSheet.addAction(googleAction)
        actionSheet.addAction(wazeAction)
        actionSheet.addAction(cancelAction)
    
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func googleHandler(alert: UIAlertAction) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?daddr=\(event.latitude),\(event.longitude)&directionsmode=driving")!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    func wazeHandler(alert: UIAlertAction) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"waze://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "waze://?ll=\(event.latitude),\(event.longitude)&navigate=yes")!)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }        
    }
}
