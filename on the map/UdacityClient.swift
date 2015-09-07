//
//  UdacityClient.swift
//  on the map
//
//  Created by Ian Gristock on 29/08/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient : RestClient {
    
    var userID: String?
    static let successfulUserLogin = "udacity.user.login.success"
    static let loginFailure = "udacity.user.invalid.login"
    
    func startUserSession(username: String, password: String,  completionHandler:(Int, [String : AnyObject]?) -> () = {_,_ in}, errorHandler:(String) -> () = {_ in}) {
        
        if username.isEmpty || password.isEmpty {
            NSNotificationCenter.defaultCenter().postNotificationName(UdacityClient.loginFailure, object: nil, userInfo:["error" : "Please supply username and password"])
            return
        }
       
        let sessionData : [String:AnyObject] = [
            "udacity" :[
            JSONBodyKeys.Username: username as String,
            JSONBodyKeys.Password: password as String]
        ]
        
        post(endPoint: Constants.SessionEndpoint, param: sessionData, range: 5,
            success: {
                responseCode, data in
                if(responseCode == HTTPResponseCodes.BAD_CREDENTIALS) {
                    errorHandler( "Invalid credentials Supplied")
                    return
                }else{
                    completionHandler(responseCode, data)
                }
            },
            
            failure: {
                errorMessage in
                errorHandler(errorMessage)
        })
    }
    
    func getUserData(key : String, completionHandler:(Int, [String : AnyObject]?) -> () = {_,_ in}, errorHandler:(String) -> () = {_ in}) {
        get(endPoint:Constants.UserDataEndpoint + key, range: 5,
            
            success:{
                responseCode, data in
                if let userData = data!["user"] as? [String:AnyObject] {
                    let user = User(userData: userData)
                    completionHandler(responseCode, ["user" :user])
                }
            },
            failure:{
                errorMessage in
                errorHandler(errorMessage)
        })

    }


    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
    override func getBaseUrl() -> String {
        return Constants.BaseURLSecure;
    }
}
