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
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForGetMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var newParameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLFromParameters(newParameters, withPathExtension: method))
        request.addValue(ParseClient.Constants.ApplicationId, forHTTPHeaderField: ParseClient.HTTPHeaderField.AppIdHeader)
        request.addValue(ParseClient.Constants.RESTAPIKey, forHTTPHeaderField: ParseClient.HTTPHeaderField.RESTAPIHeader)
        print("request: \(request)")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successfull 2xx response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
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
            
        }) 
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject]?, jsonBody: String, completionHandlerForPost: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var newParameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLFromParameters(newParameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue(Constants.ApplicationId, forHTTPHeaderField: HTTPHeaderField.AppIdHeader)
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: HTTPHeaderField.RESTAPIHeader)
        request.addValue(Constants.ContentType, forHTTPHeaderField: HTTPHeaderField.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successfull 2xx response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
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
        }) 
        
        /* 7. Start the request */
        task.resume()
        
        return task        
    }
    
    // MARK: Helpers
    
    // Given raw JSON, return a usable Foundation object
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
        
    }
    
    // Create a URL from parameters
    fileprivate func parseURLFromParameters(_ parameters: [String: AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if parameters != nil {
            for (key, value) in parameters! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.url!
        
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}






