//
//  ConvenienceFunctions.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/11/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    // Displays an error message
    func displayError(errorMessage: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Takes a user entered url and makes it a valid url
    func makeValidURLString(urlString: String) -> String? {
        
        var validURLString: String?
        
        func validateURL (stringURL : String) -> Bool {
            
            let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
            let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
            
            return predicate.evaluateWithObject(stringURL)
        }
        
        if urlString == "" {
            print("validURLString = nil")
            displayError("No URL Entered", viewController: self)
            return validURLString
        }
        
        if urlString.characters.count < 8 && urlString.characters.count > 0 {
            validURLString = "https://" + urlString
        } else {
            if urlString[0...7].lowercaseString == "https://" || urlString[0...6].lowercaseString == "http://"{
                validURLString = urlString
            } else {
                validURLString = "https://" + urlString
            }
        }
        
        if validateURL(validURLString!) {
            return validURLString
        } else {
            validURLString = nil
            displayError("Invalid URL. Try again", viewController: self)
            print("url: \(urlString) is not a valid URL")
        }
        return validURLString
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
