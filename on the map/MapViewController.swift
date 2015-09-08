//
//  MapViewController.swift
//  on the map
//
//  Created by Ian Gristock on 05/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getStudentLocations")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "addLocation")
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        // Do any additional setup after loading the view.
        mapView.delegate = self
        getStudentLocations()
    }
    
    func getStudentLocations() {
        SwiftSpinner.show("Fetching Student Locations ...")
        StudentLocationReposiotry.sharedInstance().getStudentLocations(
            {
                responseCode, studentLocations in
                var annotations = [MKPointAnnotation]()
                if let studentLocations = studentLocations as [StudentLocation]! {
                    
                    for student in studentLocations  {
                        
                        let lat = CLLocationDegrees(student.latitude as Double!)
                        let long = CLLocationDegrees(student.longitude as Double!)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = student.fullName
                        annotation.subtitle = student.mediaURL
                        
                        annotations.append(annotation)
                    }
                    
                    // Add the annotations to the map, need to be on the main thread to appear directly
                    dispatch_async(dispatch_get_main_queue(),{
                        SwiftSpinner.hide()
                        self.mapView.removeAnnotations(self.mapView.annotations)
                        self.mapView.addAnnotations(annotations)
                    });

                }

                            },
            errorHandler: {
                errorMessage in
            }
        )
    }
    
    func addLocation() {
        performSegueWithIdentifier("showInformationPosting", sender: self)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }

}