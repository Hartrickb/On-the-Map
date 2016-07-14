//
//  LoginViewController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/5/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        uiWhileLoggingInEnabled(true)
        
        postUserSession { (studentData, error) in
            if error == nil {
                self.getPublicUserData({ (studentData, error) in
                    
                    let parsedData: AnyObject!
                    do {
                        parsedData = try NSJSONSerialization.JSONObjectWithData(studentData!, options: .AllowFragments)
                    } catch {
                        print("Could not parse the data as JSON: '\(studentData)")
                        return
                    }
                    
                    // Use the data
                    guard let results = parsedData["user"] as? [String: AnyObject] else {
                        print("Unable to find key 'user' in \(parsedData)")
                        self.uiWhileLoggingInEnabled(false)
                        return
                    }
                    
                    let student = StudentInformation(studentDictionary: results)
                    self.appDelegate.student = student
                    print("student: \(self.appDelegate.student)")
                    
                })
            }
            
        }
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        //TODO: Display udacity.com
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func postUserSession(completionHander: (studentData: NSData?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.displayError("\(error)", viewController: self)
                print(error)
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsedNewDataJSON = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            if let errorString = parsedNewDataJSON["error"] as? String {
                
                var newErrorString = errorString
                
                if newErrorString == "trails.Error 400: Missing parameter 'username'" {
                    newErrorString = "Missing Username"
                }
                
                if newErrorString == "trails.Error 400: Missing parameter 'password'" {
                    newErrorString = "Missing Password"
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    self.displayError(newErrorString, viewController: self)
                    self.uiWhileLoggingInEnabled(false)
                    return
                })
            }
            
            guard let account = parsedNewDataJSON["account"] as? NSDictionary else {
                print("No key 'account' in \(parsedNewDataJSON)")
                return
            }
            if let id = account["key"] as? String {
                self.appDelegate.userID = id
                print(self.appDelegate.userID)
                completionHander(studentData: newData, error: nil)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.completeLogin()
                })
            } else {
                print("No key 'key' in \(account)")
                completionHander(studentData: newData, error: nil)
                return
            }
            
        }
        task.resume()
    }
    
    func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func getPublicUserData(completionHandler: (studentData: NSData?, error: NSError?) -> Void) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let userId = self.appDelegate.userID {
            print("userId: \(userId)")
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
                if error != nil {
                    print("error: \(error)")
                    return
                }
                
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    print("Your request returned a status code of something other than successful 2xx: \(response)")
                    return
                }
                
                guard let data = data else {
                    print("There was no data")
                    return
                }
                
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                completionHandler(studentData: newData, error: nil)
            }
            task.resume()
        }
    }
    
    func uiWhileLoggingInEnabled(enabled: Bool) {
        emailTextField.enabled = !enabled
        passwordTextField.enabled = !enabled
        loginButton.enabled = !enabled
        if enabled {
            loginActivityIndicator.startAnimating()
        } else {
            loginActivityIndicator.stopAnimating()
        }
    }
    
}
