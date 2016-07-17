//
//  StudentInformation.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/12/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation

struct StudentInformation {
    let id: String
    let firstName: String
    let lastName: String
    var mapString: String?
    var mediaURL: String?
    var lat: Double?
    var long: Double?
    
    init(dictionary: [String: AnyObject]) {
        id = dictionary["uniqueKey"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        lat = dictionary["latitude"] as? Double
        long = dictionary["longitude"] as? Double
    }
    
    init(studentDictionary: [String: AnyObject]) {
        id = studentDictionary["key"] as! String
        firstName = studentDictionary["first_name"] as! String
        lastName = studentDictionary["last_name"] as! String
        mapString = nil
        mediaURL = nil
        lat = nil
        long = nil
    }
    
    init() {
        id = ""
        firstName = ""
        lastName = ""
        mapString = nil
        mediaURL = nil
        lat = nil
        long = nil
    }
    
    static func studentsFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        // Iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
    
//    static func publicStudentDataFromResults(results: [String: AnyObject]) -> StudentInformation {
//        
//        var student = StudentInformation()
//        
//        for
//        
//    }
    
    static func publicStudentDataFromResults(results: [[String: AnyObject]]) -> StudentInformation {
        
        var student = StudentInformation()
        
        for result in results {
            student = StudentInformation(studentDictionary: result)
        }
        
        return student
        
    }
}