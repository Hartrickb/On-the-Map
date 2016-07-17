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
    
    func getPublicUserData(completionHandlerForStudent: (student: StudentInformation?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        if let studentID = UdacityClient.sharedInstance().userID {
            
            /* 2. Make the request */
            taskForGETInfo(studentID) { (results, error) in
                
                /* 3. Send the desired value(s) to the completion handler */
                if error != nil {
                    completionHandlerForStudent(student: nil, error: error)
                    return
                } else {
                    // Use the data
                    
                    guard let studentResults = results[JSONKeys.user] as? [String: AnyObject] else {
                        completionHandlerForStudent(student: nil, error: NSError(domain: "getPublicUserData key", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to find key '\(JSONKeys.user)'"]))

                        return
                    }
                    
                    let student = StudentInformation(studentDictionary: studentResults)
                    completionHandlerForStudent(student: student, error: nil)
                }
            }
        }
    }
    
    func deleteSession(completionHandlerForDeleteSession: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        // There are none...
        
        /* 2. Make the request */
        taskForDELETEMethod { (results, error) in
            if let error = error {
                print("Post error: \(error)")
                completionHandlerForDeleteSession(success: false, error: error)
            } else {
                guard let session = results[JSONKeys.session] as? [String: AnyObject] else {
                    print("No key '\(JSONKeys.session)' in \(results)")
                    return
                }
                
                if let id = session[JSONKeys.id] as? String {
                    print("logout id: \(id)")
                    completionHandlerForDeleteSession(success: true, error: nil)
                }
            }
        }
        
    }
    
}









