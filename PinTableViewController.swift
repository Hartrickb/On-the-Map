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
    
    override func viewWillAppear(_ animated: Bool) {
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
                if newError.contains("The Internet connection appears to be offline.") {
                    newError = "No internet connection. Please try again"
                }
                self.displayError(newError, viewController: self)
            }
        }
    }
    
    // Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageModel.sharedInstance().studentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell", for: indexPath) as UITableViewCell
        let pin = StorageModel.sharedInstance().studentArray[(indexPath as NSIndexPath).item]
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pin = StorageModel.sharedInstance().studentArray[(indexPath as NSIndexPath).row]
        
        let app = UIApplication.shared
        if let toOpen = pin.mediaURL {
            if let url = makeValidURLString(toOpen) {
                app.openURL(URL(string: url)!)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    
