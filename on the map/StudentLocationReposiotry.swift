//
//  StudentLocationReposiotry.swift
//  on the map
//
//  Created by Ian Gristock on 06/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

class StudentLocationReposiotry {
    
    func getStudentLocations(completionHandler:(Int, [StudentLocation]?) -> (), errorHandler:(String) -> ()) {
        ParseClient.sharedInstance().getStudentLocations(
            {
                code, data in
                var studentLocations:[StudentLocation] = [StudentLocation]()
                if let results = data!["results"] as? [AnyObject] {
                    for result in results {
                        var student = StudentLocation(dictionary: result as! NSDictionary)
                        studentLocations.append(student)
                    }
                }
                completionHandler(code, studentLocations)
            },
            errorHandler:{
                errorResponse in
                errorHandler(errorResponse)
            }
        )
    }
    
    class func sharedInstance() -> StudentLocationReposiotry {
        
        struct Singleton {
            static var sharedInstance = StudentLocationReposiotry()
        }
        
        return Singleton.sharedInstance
    }
}