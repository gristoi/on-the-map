//
//  InformationPostingViewController.swift
//  on the map
//
//  Created by Ian Gristock on 08/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//
import Foundation
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
    @IBOutlet weak var cancelButton: UIButton!
    
    let blueColor: UIColor = UIColor(red: 80.0/255, green: 138.0/255, blue: 177.0/255, alpha: 1)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationField.delegate = self
        linkField.delegate = self
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
            //change the colour of the background
            topContainer.backgroundColor = blueColor
            bottomContainer.backgroundColor = blueColor
            linkField.textColor = UIColor.whiteColor()
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
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
            if error != nil || placemarks == nil {
                let message = "Could not find address."
                self.presentViewController(Util.showAlert(message), animated: true, completion: nil);
            }
            else {
                self.toggleView(Step.Two)
                self.placemark = placemarks.first as! CLPlacemark
                let span = MKCoordinateSpan(latitudeDelta: 0.3,longitudeDelta: 0.3)
                let region = MKCoordinateRegion(center: self.placemark.location.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                var location = MKPointAnnotation()
                location.coordinate = self.placemark.location.coordinate
                self.mapView.addAnnotation(location)

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
                SwiftSpinner.hide()
                self.dismissViewControllerAnimated(true, completion: nil);
            },
            errorHandler:{
                errorResponse in
                SwiftSpinner.hide()
                dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(Util.showAlert(errorResponse), animated: true, completion: nil);
                })
            })
    }
    
   
    
}

extension InformationPostingViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if locationField.isFirstResponder() || linkField.isFirstResponder() {
            self.view.frame.origin.y = -getKeyboardHeight(notification)        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if locationField.isFirstResponder() || linkField.isFirstResponder(){
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}