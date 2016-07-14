//
//  ParseClient.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/14/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import MapKit

class ParseClient: NSObject {
    
    // Shared Session
    var session = NSURLSession.sharedSession()
    
    // Place to store recieved data
    var annotations = [MKPointAnnotation]()
    var studentArray = [StudentInformation]()
    
}
