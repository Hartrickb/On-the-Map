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
    
    override init() {
        super.init()
    }
    
    func taskForGetMethod(method: String, parameters: [String: AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var newParameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: parseURLFromParameters(newParameters, withPathExtension: method))
        request.addValue(ParseClient.Constants.ApplicationId, forHTTPHeaderField: ParseClient.HTTPHeaderField.AppIdHeader)
        request.addValue(ParseClient.Constants.RESTAPIKey, forHTTPHeaderField: ParseClient.HTTPHeaderField.RESTAPIHeader)
        print("request: \(request)")
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successfull 2xx response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than a successful 2xx")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion hander) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    func taskForPOSTMethod(method: String, parameters: [String: AnyObject]?, jsonBody: String, completionHandlerForPost: (results: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var newParameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: parseURLFromParameters(newParameters, withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HTTPHeaderField.AppIdHeader)
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: HTTPHeaderField.RESTAPIHeader)
        request.addValue(Constants.ContentType, forHTTPHeaderField: HTTPHeaderField.ContentType)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(results: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successfull 2xx response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than a successful 2xx")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task        
    }
    
    // MARK: Helpers
    
    // Given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
    }
    
    // Create a URL from parameters
    private func parseURLFromParameters(parameters: [String: AnyObject]?, withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        if parameters != nil {
            for (key, value) in parameters! {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.URL!
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}






