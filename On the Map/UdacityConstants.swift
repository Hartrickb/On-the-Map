//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/15/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    @nonobjc static let baseURL = "https://www.udacity.com/api/session"
    
    struct Constants {
        static let appJSON = "application/json"
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/users"
        
    }
    
    struct HTTPHeaders {
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    struct PostKeys {
        static let error = "error"
        static let account = "account"
        static let key = "key"
    }
    
    struct ParameterKeys {
        static let UserID = "userID"
    }
    
    struct JSONKeys {
        static let user = "user"
        static let id = "id"
        static let session = "session"
    }
    
}