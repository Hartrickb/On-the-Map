//
//  PinTableViewController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/7/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit

class PinTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Student Locations"
        
        ParseClient.sharedInstance().getStudentLocations { (results, error) in
            if let results = results {
                StorageModel.sharedInstance().studentArray = results
                performUIUpdatesOnMain({ 
                    self.tableView.reloadData()
                })
            } else {
                StorageModel.sharedInstance().studentArray.removeAll()
                self.tableView.reloadData()
                var newError = "\(error)"
                if newError.containsString("The Internet connection appears to be offline.") {
                    newError = "No internet connection. Please try again"
                }
                self.displayError(newError, viewController: self)
            }
        }
    }
    
    // Table View Data Source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageModel.sharedInstance().studentArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pinCell", forIndexPath: indexPath) as UITableViewCell
        let pin = StorageModel.sharedInstance().studentArray[indexPath.item]
        
        // Configure the cell
        var first = pin.firstName
        var last = pin.lastName
        let mediaURL = pin.mediaURL
        
        if first == nil {
            first = ""
        }
        
        if last == nil {
            last = ""
        }
        
        cell.textLabel?.text = "\(first!) \(last!)"
        cell.detailTextLabel?.text = "\(mediaURL!)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let pin = StorageModel.sharedInstance().studentArray[indexPath.row]
        
        let app = UIApplication.sharedApplication()
        if let toOpen = pin.mediaURL {
            if let url = makeValidURLString(toOpen) {
                app.openURL(NSURL(string: url)!)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

    