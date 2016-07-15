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
            
            /* 3. Send the desired value(s) to competion handler */
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
    
}