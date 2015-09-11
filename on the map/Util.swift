//
//  Util.swift
//  on the map
//
//  Created by Ian Gristock on 11/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation
import UIKit
class Util {
    
    // Display an alert to the user warning of login failure
   class func showAlert(message: String)  -> UIAlertController{
        let alertController = UIAlertController(title: "Error :", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        return alertController
    }
}