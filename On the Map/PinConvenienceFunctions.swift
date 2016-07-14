//
//  PinConvenienceFunctions.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/7/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation
import UIKit

func getStudentPins(completionHandler: (studentData: NSData?, error: NSError?) -> Void) {
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil {
            
            print(error)
            return
        }
        
        guard error == nil else {
            print("There was an error: \(error)")
            return
        }
        
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            print("Your request returned a status code of something other than successful 2xx: \(response)")
            return
        }
        
        guard let data = data else {
            print("There was no data returned with your request")
            return
        }
        
        completionHandler(studentData: data, error: nil)
        
    }
    task.resume()
}










