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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var userLocationText: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userLocation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        findOnMapButton.setTitleColor(UIColor.darkGray, for: UIControlState.disabled)

        buttonEnabled(button: findOnMapButton, bool: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        findOnMapButton.backgroundColor = UIColor.clear
        findOnMapButton.layer.cornerRadius = 5
        findOnMapButton.layer.borderWidth = 1.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userPinFromLocation" {
            let controller = segue.destination as! SubmitPostingViewController
            controller.userLocation = userLocation
        }
    }
    
    @IBAction func findOnMapButton(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "userPinFromLocation", sender: self)
        
    }
    
    @IBAction func cancelUserPosting(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func forwardGeocoding(_ address: String) {
        userLocationText.isEnabled = false
        
        performUIUpdatesOnMain { 
            self.activityIndicator.startAnimating()
        }
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                self.displayError("Could not find location. Try again", viewController: self)
                print("No location entered")
                self.activityIndicator.stopAnimating()
                self.userLocationText.isEnabled = true
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
                self.userLocationText.isEnabled = true
                self.buttonEnabled(button: self.findOnMapButton, bool: true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            displayError("No text entered", viewController: self)
            print("No text entered")
        } else {
            StorageModel.sharedInstance().student.mapString = textField.text!
            forwardGeocoding(textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buttonEnabled(button: findOnMapButton, bool: false)
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
