//
//  ParseConstants.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/15/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

extension ParseClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentType = "application/json"
    }
    
    struct Methods {
        static let StudentsLocations = "/StudentLocation"
    }
    
    struct HTTPHeaderField {
        static let AppIdHeader = "X-Parse-Application-Id"
        static let RESTAPIHeader = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
    }
    
    struct StudentLocationParameterKey {
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
    }
    
    struct StudentLocationParameterValues {
        static let limit = "10"
        static let skip: String? = nil
        static let order = "-updatedAt"
    }
    
    struct JSONResponseKeys {
        static let Results = "results"
        static let CreatedAt = "createdAt"
        static let ObjectId = "objectId"
    }
    
}






