//
//  MapViewController.swift
//  On the Map
//
//  Created by Bennett Hartrick on 7/5/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StorageModel.sharedInstance().annotations.removeAll()
        StorageModel.sharedInstance().studentArray.removeAll()
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        loadPinsForMap()
    }
    
    // Downloads the data from parse and stores it in the ParseClient.StudentArray
    func loadPinsForMap() {
        ParseClient.sharedInstance().getStudentLocations { (results, error) in
            if let results = results {
                StorageModel.sharedInstance().studentArray = results
                performUIUpdatesOnMain({
                    self.displayPins()
                })
            } else {
                var newError = "\(error)"
                if newError.contains("The Internet connection appears to be offline.") {
                    newError = "No internet connection. Please try again"
                }
                self.displayError(newError, viewController: self)
            }
        }
    }
    
    // Takes the data returned from loadPinsForMap that is stored in
    // ParseClient.sharedInstance().studentArray and displays the pins on map
    func displayPins() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        
        // Converts the array to annotations that the mapView can use
        for student in StorageModel.sharedInstance().studentArray {
            let lat = CLLocationDegrees(student.lat!)
            let long = CLLocationDegrees(student.long!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            var first = student.firstName
            var last = student.lastName
            let mediaURL = student.mediaURL
            
            if first == nil {
                first = " "
            }
            
            if last == nil {
                last = " "
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first!) \(last!)"
            annotation.subtitle = mediaURL
            
            StorageModel.sharedInstance().annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(StorageModel.sharedInstance().annotations)
    }
    
    // Creates a pin / annotation for the map view
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
    
    
    // Opens the url of the pin in Safari
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let url = makeValidURLString(toOpen) {
                    app.openURL(URL(string: url)!)
                }
            }
        }
    }
}













