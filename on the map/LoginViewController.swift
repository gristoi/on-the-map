//
//  ViewController.swift
//  on the map
//
//  Created by Ian Gristock on 29/08/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.layerGradient()
        activityIndicator.hidden = true
        emailTextField.setTextLeftPadding(15.00)
        passwordTextField.setTextLeftPadding(15.00)
    }
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        loginButton.setTitle("Authenticating", forState: UIControlState.Normal)
         activityIndicator.hidden = false
         activityIndicator.startAnimating()
         UserRepository.sharedInstance().login(emailTextField.text!, password: passwordTextField.text!,
            completionHandler: {
                reposnseCode, data in
                let userInfo = data as [String:AnyObject]!
                if let user = userInfo["user"] as? User {
                    // serialize and shove the user object into the ns user defaults
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(user), forKey: "User")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("successfulLogin", sender: self)
                    })
                }
            },
            errorHandler: {
                errorResponse in
                dispatch_async(dispatch_get_main_queue(), {
                    self.loginButton.setTitle("Login", forState: UIControlState.Normal)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.showLoginAlert(errorResponse)
                })
            })
    }

    @IBAction func signupButtonTapped(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://www.udacity.com/account/auth#!/signup")!)
    }
    
    // Display an alert to the user warning of login failure
    func showLoginAlert(message: String) {
        let alertController = UIAlertController(title: "Error Logging In", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}



extension UIView {
    
    func layerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPointMake(0.0,0.0)
        
        let color0 = UIColor(red:255.0/255, green:152/255, blue:11/255, alpha:1).CGColor
        let color1 = UIColor(red:255/255, green:111/255, blue:0/255, alpha:1).CGColor
        
        layer.colors = [color0,color1]
        self.layer.insertSublayer(layer, atIndex: 0)
    }
}


// solution found at https://gist.github.com/namanhams/dc3b491557ec6fb12060
extension UITextField {
    func setTextLeftPadding(left:CGFloat) {
        var leftView:UIView = UIView(frame: CGRectMake(0, 0, left, 1))
        leftView.backgroundColor = UIColor.clearColor()
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewMode.Always;
    }
}

