//
//  AppDelegate.swift
//  check
//
//  Created by angelito on 12/21/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      self.prepareNavigationBarAppearance()
      GMSServices.provideAPIKey("AIzaSyDWwPs79-kZZpeIRMobbu62nlq-E_x_-LQ")
      return true      
    }
  
  func prepareNavigationBarAppearance() {
    
    let BarColor = UIColor(red:0.037, green:0.468, blue:0.707, alpha:1.0)
    
    UINavigationBar.appearance().barTintColor = BarColor
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().translucent = false
    
    let font = UIFont(name: "Avenir", size: 16)!
    let regularVertical = UITraitCollection(verticalSizeClass:.Regular)
    let titleDict : Dictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font]
    
    UINavigationBar.appearanceForTraitCollection(regularVertical).titleTextAttributes = titleDict
    

  }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

