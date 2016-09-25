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
        userLocationMap.camera.altitude *= 10
        submitButton.setTitleColor(UIColor.darkGray, for: UIControlState.disabled)
        buttonEnabled(button: submitButton, bool: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitButton.backgroundColor = UIColor.clear
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1.5
    }
    
    @IBAction func submitUserLocationWithURL(_ sender: AnyObject) {
        
        let student = StorageModel.sharedInstance().student
        
        ParseClient.sharedInstance().postStudentLocationForStudent(student) { (success, error) in
            if success {
                self.performSegue(withIdentifier: "submit", sender: sender)
            } else {
                var newError = "\(error!.localizedDescription)"
                if newError.contains("The Internet connection appears to be offline.") {
                    newError = "No internet connection. Please try again"
                }
                self.displayError(newError, viewController: self)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let url = textField.text else {
            submitButton.isEnabled = false
            submitButton.layer.borderColor = UIColor.darkGray.cgColor
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
    
    func buttonEnabled(button: UIButton, bool: Bool) {
        button.isEnabled = bool
        if button.isEnabled {
            button.layer.borderColor = UIColor.white.cgColor
        } else {
            button.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
}
