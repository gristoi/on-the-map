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
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshStudents")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "addLocation")
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadMap()
        super.viewWillAppear(animated)
    }
    
    func loadMap() {
        let studentRepo = StudentLocationRepository.sharedInstance()
        SwiftSpinner.show("Fetching Student Locations ...")
        if studentRepo.dataFetched {
            self.reloadPins(studentRepo.studentLocations)
        } else {
            self.refreshStudents()
        }

    }
    
    func refreshStudents() {
        SwiftSpinner.show("Fetching Student Locations ...")
        StudentLocationRepository.sharedInstance().getStudentLocations(
            {
                responseCode, studentLocations in
                self.reloadPins(studentLocations!)
                
            },
            errorHandler: {
                errorMessage in
                SwiftSpinner.hide()
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(Util.showAlert(errorMessage), animated: true, completion: nil);
                })
            }
        )
    }
    
    func reloadPins(studentLocations: [StudentLocation]) {
        
        var annotations = [MKPointAnnotation]()
        if let studentLocations = studentLocations as [StudentLocation]! {
            
            for student in studentLocations  {
                
                let latitude = CLLocationDegrees(student.latitude as Double!)
                let longitude = CLLocationDegrees(student.longitude as Double!)
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                var annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = student.fullName
                annotation.subtitle = student.mediaURL
                
                annotations.append(annotation)
            }
            dispatch_async(dispatch_get_main_queue(),{
                SwiftSpinner.hide()
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            });
            
        }
    }
    
   
    @IBAction func logout(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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