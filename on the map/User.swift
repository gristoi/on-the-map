//
//  User.swift
//  on the map
//
//  Created by Ian Gristock on 05/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

class User : NSObject,  NSCoding {
    
    var userId: String?
    var firstName: String?
    var lastName: String?
    
    init(userData: [String:AnyObject]) {
        
        if let userId = userData["key"] as? String {
            self.userId = userId
        }
        
        if let firstName = userData["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = userData["last_name"] as? String {
            self.lastName = lastName
        }
        super.init()
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        // do not call super in this case
        coder.encodeObject(self.userId, forKey: "userId")
        coder.encodeObject(self.lastName, forKey: "last")
        coder.encodeObject(self.firstName, forKey: "first")
    }
    
    required init(coder: NSCoder) {
        self.userId = coder.decodeObjectForKey("userId") as? String
        self.lastName = coder.decodeObjectForKey("last") as? String
        self.firstName = coder.decodeObjectForKey("first") as? String
        // do not call super init(coder:) in this case
        super.init()
    }

}