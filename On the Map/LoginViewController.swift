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
    
    @IBAction func loginButton(_ sender: AnyObject) {
        
        performUIUpdatesOnMain { 
            self.uiWhileLoggingInEnabled(true)
        }
        
        UdacityClient.sharedInstance().postSession(emailTextField.text, password: passwordTextField.text) { (studentID, error) in
            if let studentID = studentID {
                
                StorageModel.sharedInstance().userID = studentID
                print("Successfully got studentID: \(StorageModel.sharedInstance().userID)")
                
                UdacityClient.sharedInstance().getPublicUserData({ (student, error) in
                    if let student = student {
                        StorageModel.sharedInstance().student = student
                        print("StudentInfo: \(StorageModel.sharedInstance().student)")
                        self.completeLogin()
                    }
                })
            } else {
                var newErrorString = "\(error)"
                
                if newErrorString.contains("The Internet connection appears to be offline.") {
                    newErrorString = "No internet connection. Please try again"
                }
                
                if newErrorString.contains("trails.Error 400: Missing parameter 'username'") {
                    newErrorString = "Missing Username"
                }
                
                if newErrorString.contains("trails.Error 400: Missing parameter 'password'") {
                    newErrorString = "Missing Password"
                }
                
                if newErrorString.contains("Account not found or invalid credentials.") {
                    newErrorString = "Account not found or invalid credentials"
                }
                
                performUIUpdatesOnMain {
                    self.displayError("\(newErrorString)", viewController: self)
                    self.uiWhileLoggingInEnabled(false)
                }
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: AnyObject) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.openURL(url)
        }
    }
    
    func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    
    func uiWhileLoggingInEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = !enabled
        passwordTextField.isEnabled = !enabled
        loginButton.isEnabled = !enabled
        if enabled {
            loginActivityIndicator.startAnimating()
        } else {
            loginActivityIndicator.stopAnimating()
        }
    }
    
}
