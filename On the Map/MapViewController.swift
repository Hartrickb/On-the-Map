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
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var pins: [[String: AnyObject]] {
//        get {
//            return appDelegate.pins
//        } set {
//            appDelegate.pins = pins
//        }
//    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadPinsForMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Gets student pins and copies them to pinData
    }
    
    
    
    func displayPins() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        
        for student in appDelegate.studentArray {
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
            
            appDelegate.annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(appDelegate.annotations)
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
                if let url = makeValidURLString(toOpen) {
                    app.openURL(NSURL(string: url)!)
                }
            }
        }
    }
    
    func loadPinsForMap() {
        
        getStudentPins({ (studentData, error) in
            let parsedData: AnyObject!
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(studentData!, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(studentData)")
                return
            }
            
            // Use the data
            guard let results = parsedData["results"] as? [[String: AnyObject]] else {
                print("Unable to find key 'results' in \(parsedData)")
                return
            }
            
            self.appDelegate.studentArray = StudentInformation.studentsFromResults(results)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.displayPins()
            })
            
        })
    }
    
}













