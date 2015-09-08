//
//  InformationPostingViewController.swift
//  on the map
//
//  Created by Ian Gristock on 08/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    var placemark:CLPlacemark!
    
    enum Step {
        case One
        case Two
    }
    
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findOnMapButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toggleView(Step.One)
    }

    func toggleView(step: Step) {
        if step == Step.One {
            // show first step
            studyLabel.hidden = false
            locationField.hidden = false
            findOnMapButton.hidden = false
            
            // hide second step
            linkField.hidden = true
            mapView.hidden = true
            submitButton.hidden = true
        } else {
            // hide first step
            studyLabel.hidden = true
            locationField.hidden = true
            findOnMapButton.hidden = true
            
            // show second step
            linkField.hidden = false
            mapView.hidden = false
            submitButton.hidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapButtonClicked(sender: UIButton) {
        let geocoder = CLGeocoder()
        SwiftSpinner.show("Locating Address")
        geocoder.geocodeAddressString(locationField.text, completionHandler: {(placemarks:[AnyObject]!, error:NSError!) in
            SwiftSpinner.hide()
            sender.enabled = true
            if error != nil || placemarks == nil || placemarks.count == 0 {
                let message = "Could not geocode the String."
                var alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                self.toggleView(Step.Two)
                self.placemark = placemarks.first as! CLPlacemark
                let span = MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2)
                let region = MKCoordinateRegion(center: self.placemark.location.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                self.mapView.userInteractionEnabled = false
                var selectedLocation = MKPointAnnotation()
                selectedLocation.coordinate = self.placemark.location.coordinate
                self.mapView.addAnnotation(selectedLocation)

            }
        })
    }
    @IBAction func submitButtonClicked(sender: AnyObject) {
        
            let defaults = NSUserDefaults.standardUserDefaults()
            let data = defaults.objectForKey("User") as? NSData
            let unarc = NSKeyedUnarchiver(forReadingWithData: data!)
            let user = unarc.decodeObjectForKey("root") as! User
        
        
        let params:[String:AnyObject] =
            ["uniqueKey": user.userId!,
            "firstName": user.firstName!,
            "lastName" : user.lastName!,
            "mapString": locationField.text!,
            "mediaURL" : linkField.text!,
            "latitude" : placemark.location.coordinate.latitude,
            "longitude": placemark.location.coordinate.longitude]
        println(params)
        var studentLocation = StudentLocation(dictionary: params)
        SwiftSpinner.show("Saving Location ...")
        ParseClient.sharedInstance().createStudentLocation(studentLocation,
            completionHandler: {
                responseCode, data in
                println(responseCode, data)
                SwiftSpinner.hide()
                self.dismissViewControllerAnimated(true, completion: nil);
            },
            errorHandler:{
                errorResponse in
                SwiftSpinner.hide()
                var alert = UIAlertController(title: "", message: errorResponse, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
    }
}
