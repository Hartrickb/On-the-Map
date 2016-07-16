//
//  LoginViewController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/5/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        performUIUpdatesOnMain { 
            self.uiWhileLoggingInEnabled(true)
        }
        
        UdacityClient.sharedInstance().postSession(emailTextField.text, password: passwordTextField.text) { (studentID, error) in
            if let studentID = studentID {
                UdacityClient.sharedInstance().userID = studentID
                self.completeLogin()
                print("Successfully got studentID: \(UdacityClient.sharedInstance().userID)")
            } else {
                var newErrorString = "\(error)"
                
                if newErrorString.containsString("trails.Error 400: Missing parameter 'username'") {
                    newErrorString = "Missing Username"
                }
                
                if newErrorString.containsString("trails.Error 400: Missing parameter 'password'") {
                    newErrorString = "Missing Password"
                }
                
                if newErrorString.containsString("Account not found or invalid credentials.") {
                    newErrorString = "Account not found or invalid credentials"
                }
                
                performUIUpdatesOnMain {
                    self.displayError("\(newErrorString)", viewController: self)
                    self.uiWhileLoggingInEnabled(false)
                }
            }
        }
        
//        postUserSession { (studentData, error) in
//            if error == nil {
//                self.getPublicUserData({ (studentData, error) in
//                    
//                    let parsedData: AnyObject!
//                    do {
//                        parsedData = try NSJSONSerialization.JSONObjectWithData(studentData!, options: .AllowFragments)
//                    } catch {
//                        print("Could not parse the data as JSON: '\(studentData)")
//                        return
//                    }
//                    
//                    // Use the data
//                    guard let results = parsedData["user"] as? [String: AnyObject] else {
//                        print("Unable to find key 'user' in \(parsedData)")
//                        self.uiWhileLoggingInEnabled(false)
//                        return
//                    }
//                    
//                    let student = StudentInformation(studentDictionary: results)
//                    UdacityClient.sharedInstance().student = student
//                    print("student: \(UdacityClient.sharedInstance().student)")
//                    
//                })
//            }
//            
//        }
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
    
//    func getPublicUserData(completionHandler: (studentData: NSData?, error: NSError?) -> Void) {
////        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        if let userId = self.appDelegate.userID {
//            print("userId: \(userId)")
//            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)
//            let session = NSURLSession.sharedSession()
//            let task = session.dataTaskWithRequest(request) { (data, response, error) in
//                if error != nil {
//                    print("error: \(error)")
//                    return
//                }
//                
//                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                    print("Your request returned a status code of something other than successful 2xx: \(response)")
//                    return
//                }
//                
//                guard let data = data else {
//                    print("There was no data")
//                    return
//                }
//                
//                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
//                completionHandler(studentData: newData, error: nil)
//            }
//            task.resume()
//        }
//    }
    
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
