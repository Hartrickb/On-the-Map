//
//  TabBarController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/5/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    
    @IBAction func logoutButton(sender: AnyObject) {
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.color = UIColor.blackColor()
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        performUIUpdatesOnMain({
            activityView.startAnimating()
            self.view.addSubview(activityView)
        })
        
        UdacityClient.sharedInstance().deleteSession { (success, error) in
            
            var newError = "\(error)"
            if newError.containsString("The Internet connection appears to be offline.") {
                newError = "No internet connection. Please try again"
            }
            
            if success {
                performUIUpdatesOnMain({ 
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginScreen")
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                performUIUpdatesOnMain({
                    activityView.stopAnimating()
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginScreen")
                    self.presentViewController(controller, animated: true, completion: nil)
                    self.displayError(newError, viewController: self)
                })
            }
        }
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        refreshPins()
    }
    
    func refreshPins() {
        let mapViewController = self.viewControllers![0] as! MapViewController
        let pinTableViewController = self.viewControllers![1] as! PinTableViewController
        
        
        StorageModel.sharedInstance().annotations.removeAll()
        StorageModel.sharedInstance().studentArray.removeAll()
        let annotations = mapViewController.mapView.annotations
        mapViewController.mapView.removeAnnotations(annotations)
        mapViewController.displayPins()
        
        ParseClient.sharedInstance().getStudentLocations { (results, error) in
            
            if let results = results {
                StorageModel.sharedInstance().studentArray = results
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    mapViewController.displayPins()
                    pinTableViewController.tableView.reloadData()
                    print("Data Reloaded")
                    
                })
            } else {
                performUIUpdatesOnMain({ 
                    pinTableViewController.tableView.reloadData()
                })
                self.displayError("There was an error reloading", viewController: self)
                print("Error Reloading")
            }
        }
    }
}
