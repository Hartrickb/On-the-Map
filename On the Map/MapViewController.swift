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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ParseClient.sharedInstance().annotations.removeAll()
        ParseClient.sharedInstance().studentArray.removeAll()
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        loadPinsForMap()
    }
    
    // Downloads the data from parse and stores it in the ParseClient.StudentArray
    func loadPinsForMap() {
        ParseClient.sharedInstance().getStudentLocations { (results, error) in
            if let results = results {
                ParseClient.sharedInstance().studentArray = results
                performUIUpdatesOnMain({
                    self.displayPins()
                })
            } else {
                self.displayError("\(error)", viewController: self)
            }
        }
    }
    
    // Takes the data returned from loadPinsForMap that is stored in
    // ParseClient.sharedInstance().studentArray and displays the pins on map
    func displayPins() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        
        // Converts the array to annotations that the mapView can use
        for student in ParseClient.sharedInstance().studentArray {
            let lat = CLLocationDegrees(student.lat!)
            let long = CLLocationDegrees(student.long!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            ParseClient.sharedInstance().annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(ParseClient.sharedInstance().annotations)
    }
    
    // Creates a pin / annotation for the map view
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
    
    
    // Opens the url of the pin in Safari
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                if let url = makeValidURLString(toOpen) {
                    app.openURL(NSURL(string: url)!)
                }
            }
        }
    }
}













