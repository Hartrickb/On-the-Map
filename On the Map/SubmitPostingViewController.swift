//
//  SubmitPostingViewController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/8/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import MapKit

class SubmitPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var userLocationMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var userURL = ""
    var userLocation = MKPointAnnotation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        userLocationMap.addAnnotation(userLocation)
        userLocationMap.showAnnotations(userLocationMap.annotations, animated: true)
        submitButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled)
        buttonEnabled(button: submitButton, bool: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        submitButton.backgroundColor = UIColor.clearColor()
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1.5
    }
    
    @IBAction func submitUserLocationWithURL(sender: AnyObject) {
        
        let student = StorageModel.sharedInstance().student
        
        ParseClient.sharedInstance().postStudentLocationForStudent(student) { (success, error) in
            if success {
                self.performSegueWithIdentifier("submit", sender: sender)
            } else {
                var newError = "\(error!.localizedDescription)"
                if newError.containsString("The Internet connection appears to be offline.") {
                    newError = "No internet connection. Please try again"
                }
                self.displayError(newError, viewController: self)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let url = textField.text else {
            submitButton.enabled = false
            submitButton.layer.borderColor = UIColor.darkGrayColor().CGColor
            displayError("No URL entered in textfield", viewController: self)
            print("No url entered in urlTextField")
            return
        }
        
        if let userURL = makeValidURLString(url) {
            StorageModel.sharedInstance().student.mediaURL = userURL
            buttonEnabled(button: submitButton, bool: true)
            print(userURL)
        } else {
            buttonEnabled(button: submitButton, bool: false)
        }
    }
    
    func buttonEnabled(button button: UIButton, bool: Bool) {
        button.enabled = bool
        if button.enabled {
            button.layer.borderColor = UIColor.whiteColor().CGColor
        } else {
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
        }
    }
    
}
