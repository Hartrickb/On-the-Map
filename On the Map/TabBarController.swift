//
//  TabBarController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/5/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.logout()
            })
            
        }
        task.resume()
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        refreshPins()
    }
    
    func logout() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("LoginScreen") 
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func refreshPins() {
        let mapViewController = self.viewControllers![0] as! MapViewController
        let pinTableViewController = self.viewControllers![1] as! PinTableViewController
        
        
        ParseClient.sharedInstance().annotations.removeAll()
        ParseClient.sharedInstance().studentArray.removeAll()
        let annotations = mapViewController.mapView.annotations
        mapViewController.mapView.removeAnnotations(annotations)
        mapViewController.displayPins()
        
        getStudentPins { (studentData, error) in
            
            let parsedData: AnyObject!
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(studentData!, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(studentData)")
                return
            }
            
            // Use the data
            guard let results = parsedData["results"] as? [[String: AnyObject]] else {
                print("Unable to find key 'results' in \(parsedData)")
                return
            }
            
            ParseClient.sharedInstance().studentArray = StudentInformation.studentsFromResults(results)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                mapViewController.displayPins()
                pinTableViewController.tableView.reloadData()
                print("Data Reloaded")
                
            })
            
        }
    }

}
