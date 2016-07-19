//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/8/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var userLocationText: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userLocation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        findOnMapButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled)

        buttonEnabled(button: findOnMapButton, bool: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        findOnMapButton.backgroundColor = UIColor.clearColor()
        findOnMapButton.layer.cornerRadius = 5
        findOnMapButton.layer.borderWidth = 1.5
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userPinFromLocation" {
            let controller = segue.destinationViewController as! SubmitPostingViewController
            controller.userLocation = userLocation
        }
    }
    
    @IBAction func findOnMapButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("userPinFromLocation", sender: self)
        
    }
    
    @IBAction func cancelUserPosting(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func forwardGeocoding(address: String) {
        userLocationText.enabled = false
        activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                self.displayError("Could not find location. Try again", viewController: self)
                print("No location entered")
                self.activityIndicator.stopAnimating()
                self.userLocationText.enabled = true
                return
            }
            
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                self.userLocation.coordinate = coordinate!
                StorageModel.sharedInstance().student.lat = coordinate?.latitude
                StorageModel.sharedInstance().student.long = coordinate?.longitude
                print("self.userLocation.coordinate: \(self.userLocation.coordinate)")
                print("\nlat: \(coordinate?.latitude), long: \(coordinate?.longitude)")
                self.activityIndicator.stopAnimating()
                self.userLocationText.enabled = true
                self.buttonEnabled(button: self.findOnMapButton, bool: true)
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            displayError("No text entered", viewController: self)
            print("No text entered")
        } else {
            StorageModel.sharedInstance().student.mapString = textField.text!
            forwardGeocoding(textField.text!)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        buttonEnabled(button: findOnMapButton, bool: false)
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
