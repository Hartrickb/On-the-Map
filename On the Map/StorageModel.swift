//
//  StorageModel.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/19/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import MapKit

class StorageModel: NSObject {
    
    // Info Storage
    var userID: String?
    var student = StudentInformation()
    
    // Place to store recieved data
    var annotations = [MKPointAnnotation]()
    var studentArray = [StudentInformation]()
    
    override init() {
        super.init()
    }
    
    class func sharedInstance() -> StorageModel {
        struct Singleton {
            static var sharedInstance = StorageModel()
        }
        return Singleton.sharedInstance
    }
    
}
