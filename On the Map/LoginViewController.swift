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
                print("Successfully got studentID: \(UdacityClient.sharedInstance().userID)")
                
                UdacityClient.sharedInstance().getPublicUserData({ (student, error) in
                    if let student = student {
                        UdacityClient.sharedInstance().student = student
                        print("StudentInfo: \(UdacityClient.sharedInstance().student)")
                        self.completeLogin()
                    }
                })
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
