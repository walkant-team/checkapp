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

}
