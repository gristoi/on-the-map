//
//  StudentLocationReposiotry.swift
//  on the map
//
//  Created by Ian Gristock on 06/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

class StudentLocationRepository {
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    var dataFetched: Bool = false
    
    
    func getStudentLocations(completionHandler:(Int, [StudentLocation]?) -> (), errorHandler:(String) -> ()) {
        ParseClient.sharedInstance().getStudentLocations(
            {
                code, data in
                if let results = data!["results"] as? [AnyObject] {
                    for result in results {
                        var student = StudentLocation(dictionary: result as! NSDictionary)
                        self.studentLocations.append(student)                        
                    }
                }
                self.dataFetched = true
                completionHandler(code, self.studentLocations)
            },
            errorHandler:{
                errorResponse in
                errorHandler(errorResponse)
            }
        )
    }
    
    class func sharedInstance() -> StudentLocationRepository {
        
        struct Singleton {
            static var sharedInstance = StudentLocationRepository()
        }
        
        return Singleton.sharedInstance
    }
}