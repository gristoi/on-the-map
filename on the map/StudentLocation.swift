//
//  File.swift
//  on the map
//
//  Created by Ian Gristock on 06/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId:String?
    var uniqueKey:String?
    var firstName:String?
    var lastName:String?
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    var fullName: String?
        {
        get
        {
            var firstName = ""
            if self.firstName != nil {
                firstName = self.firstName!
            }
            
            var lastName = ""
            if self.lastName != nil {
                lastName = self.lastName!
            }
            return "\(firstName) \(lastName)"
        }
    }
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
    }
}