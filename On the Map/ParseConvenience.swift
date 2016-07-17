//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/15/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import Foundation

extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    func getStudentLocations(completionHandlerForStudents: (result: [StudentInformation]?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [ParseClient.StudentLocationParameterKey.limit: ParseClient.StudentLocationParameterValues.limit]
        let method = Methods.StudentsLocations
        
        /* 2. Make the request */
        taskForGetMethod(method, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudents(result: nil, error: error)
            } else {
                if let results = results[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] {
                    let students = StudentInformation.studentsFromResults(results)
                    completionHandlerForStudents(result: students, error: nil)
                } else {
                    completionHandlerForStudents(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    func postStudentLocationForStudent(student: StudentInformation, completionHandlerForPostLocation: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        guard student.lat != nil else {
            completionHandlerForPostLocation(success: false, error: NSError(domain: "postStudentLocationForStudent", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Latitude. Try again"]))
            return
        }
        
        guard student.long != nil else {
            completionHandlerForPostLocation(success: false, error: NSError(domain: "postStudentLocationForStudent", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Longitude. Try again"]))
            return
        }
        
        guard student.mapString != nil else {
            completionHandlerForPostLocation(success: false, error: NSError(domain: "postStudentLocationForStudent", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Longitude. Try again"]))
            return
        }
        
        guard student.mediaURL != nil else {
            completionHandlerForPostLocation(success: false, error: NSError(domain: "postStudentLocationForStudent", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Longitude. Try again"]))
            return
        }
        
        let method = Methods.StudentsLocations
        
        let jsonBody = "{\"uniqueKey\": \"\(student.id)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\": \(student.lat!), \"longitude\": \(student.long!)}"
        
        /* 2. Make the request */
        taskForPOSTMethod(method, parameters: nil, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Sent the desired value(s) to completion handler */
            if let error = error {
                print("Post error: \(error)")
                completionHandlerForPostLocation(success: false, error: error)
            } else {
                if let objectId = results[JSONResponseKeys.ObjectId] as? String {
                    print("objectId: \(objectId)")
                    completionHandlerForPostLocation(success: true, error: nil)
                }
            }
        }
    }
}