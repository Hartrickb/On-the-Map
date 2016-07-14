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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        userLocationMap.addAnnotation(userLocation)
        userLocationMap.showAnnotations(userLocationMap.annotations, animated: true)
        submitButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled)
        submitButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func submitUserLocationWithURL(sender: AnyObject) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(appDelegate.student.id)\", \"firstName\": \"\(appDelegate.student.firstName)\", \"lastName\": \"\(appDelegate.student.lastName)\",\"mapString\": \"\(appDelegate.student.mapString!)\", \"mediaURL\": \"\(appDelegate.student.mediaURL!)\",\"latitude\": \(appDelegate.student.lat!), \"longitude\": \(appDelegate.student.long!)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        performSegueWithIdentifier("submit", sender: sender)
        
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
            displayError("No URL entered in textfield", viewController: self)
            print("No url entered in urlTextField")
            return
        }
        
        if let userURL = makeValidURLString(url) {
            appDelegate.student.mediaURL = userURL
            submitButton.enabled = true
            print(userURL)
        } else {
            submitButton.enabled = false
        }
    }
}
