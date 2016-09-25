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
    func displayError(_ errorMessage: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Takes a user entered url and makes it a valid url
    func makeValidURLString(_ urlString: String) -> String? {
        
        var validURLString: String?
        
        func validateURL (_ stringURL : String) -> Bool {
            
            let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
            let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
            
            return predicate.evaluate(with: stringURL)
        }
        
        if urlString == "" {
            print("validURLString = nil")
            displayError("No URL Entered", viewController: self)
            return validURLString
        }
        
//        if urlString.characters.count < 8 && urlString.characters.count > 0 {
//            validURLString = "https://" + urlString
//        } else {
//            if urlString[0...7].lowercased() == "https://" || urlString[0...6].lowercased() == "http://"{
//                validURLString = urlString
//            } else {
//                validURLString = "https://" + urlString
//            }
//        }
        
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
