//
//  UserRepository.swift
//  on the map
//
//  Created by Ian Gristock on 06/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

class UserRepository {
    
    func login(username: String, password: String, completionHandler:(Int, [String : AnyObject]?) -> () = {_,_ in}, errorHandler:(String) -> () = {_ in}) {
        UdacityClient.sharedInstance().startUserSession(username, password: password,
            completionHandler: {
                code, responseData in
                let account = responseData!["account"] as! [String:AnyObject]
                let key = account["key"] as! String
                UdacityClient.sharedInstance().getUserData(key,
                    completionHandler:{
                        code, responseData in
                        completionHandler(code, responseData)
                    },
                    errorHandler:{
                        errorResponse in
                        errorHandler(errorResponse)
                    })
                
            }, errorHandler: {
                errorMessage in
                errorHandler(errorMessage)
            })
    }
    
    class func sharedInstance() -> UserRepository {
        
        struct Singleton {
            static var sharedInstance = UserRepository()
        }
        
        return Singleton.sharedInstance
    }
}