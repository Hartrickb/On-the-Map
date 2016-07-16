//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/15/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func postSession(userName: String?, password: String?, completionHandlerForSession: (studentID: String?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        guard userName != nil else {
            completionHandlerForSession(studentID: nil, error: NSError(domain: "No Username", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Username was entered. Try again"]))
            return
        }
        
        guard password != nil else {
            completionHandlerForSession(studentID: nil, error: NSError(domain: "No Password", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Password was entered. Try again"]))
            return
        }
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(userName!)\", \"password\": \"\(password!)\"}}"
        
        /* 2. Make the request */
        taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if error != nil {
                completionHandlerForSession(studentID: nil, error: error)
                return
            }
            
            guard let account = results[PostKeys.account] as? NSDictionary else {
                completionHandlerForSession(studentID: nil, error: NSError(domain: "postSession key", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find key '\(PostKeys.account)' in \(results)"]))
                return
            }
            
            if let id = account[PostKeys.key] as? String {
                completionHandlerForSession(studentID: id, error: nil)
            } else {
                completionHandlerForSession(studentID: nil, error: NSError(domain: "postSession key", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find key '\(PostKeys.key); in \(results)"]))
            }
        }
    }
}









