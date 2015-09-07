//
//  UdacityClientConstants.swift
//  on the map
//
//  Created by Ian Gristock on 29/08/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // Constants
    struct Constants {
        
        // URLs
        static let BaseURL : String = "http://www.udacity.com/api/"
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
        static let SessionEndpoint : String = "session"
        static let UserDataEndpoint : String = "users/"
        static let SubSetRange: Int = 5
    }
    
    // JSON Body Keys
    struct JSONBodyKeys {
        static let header = "\"udacity\":"
        
        static let Username = "username"
        static let Password = "password"
    }
}