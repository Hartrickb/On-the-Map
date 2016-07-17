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
                ParseClient.sharedInstance().studentArray = results
                performUIUpdatesOnMain({ 
                    self.tableView.reloadData()
                })
            } else {
                self.displayError("\(error)", viewController: self)
            }
        }
    }
    
    // Table View Data Source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pinCell", forIndexPath: indexPath) as UITableViewCell
        let pin = ParseClient.sharedInstance().studentArray[indexPath.item]
        
        // Configure the cell
        let first = pin.firstName
        let last = pin.lastName
        let mediaURL = pin.mediaURL
        
        cell.textLabel?.text = "\(first) \(last)"
        cell.detailTextLabel?.text = "\(mediaURL!)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let pin = ParseClient.sharedInstance().studentArray[indexPath.row]
        
        let app = UIApplication.sharedApplication()
        if let toOpen = pin.mediaURL {
            if let url = makeValidURLString(toOpen) {
                app.openURL(NSURL(string: url)!)
            }
        }
    }
}

    