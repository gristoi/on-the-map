//
//  ParseClient.swift
//  on the map
//
//  Created by Ian Gristock on 01/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

class ParseClient: RestClient  {
    
    override init() {
        super.init()
        headers[Constants.ParseAppId] = "X-Parse-Application-Id"
        headers[Constants.ParseApiKey] = "X-Parse-REST-API-Key"
    }
    
    
    override func getBaseUrl() -> String {
        return Constants.BaseURL;
    }
    
    func getStudentLocations(completionHandler:(Int, [String : AnyObject]?) -> (), errorHandler:(String) -> ()) {
        
        get(endPoint: Constants.StudentLocations, param: nil,
            success:{
                responseCode, data in
                completionHandler(responseCode, data)
            }, failure: {
                errorString in
                errorHandler(errorString)
        })
    }
    
    func createStudentLocation(studentLocation: StudentLocation, completionHandler:(Int, [String : AnyObject]?) -> (), errorHandler:(String) -> ()) {
        
        let params:[String:AnyObject] = [
            "uniqueKey": studentLocation.uniqueKey!,
            "firstName": studentLocation.firstName!,
            "lastName": studentLocation.lastName!,
            "mapString": studentLocation.mapString!,
            "mediaURL": studentLocation.mediaURL!,
            "latitude": studentLocation.latitude!,
            "longitude": studentLocation.longitude!]

        post(endPoint:Constants.StudentLocations, param: params,
            success: {
                responseCode, data in
                completionHandler(responseCode, data)
            },
            failure:{
                errorResponse in
                errorHandler(errorResponse)
            }
        )
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}

extension ParseClient {
    
    struct Constants {
        
        // URL
        static let BaseURL : String = "https://api.parse.com/1/"
        static let ParseAppId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let StudentLocations: String = "classes/StudentLocation?limit=100"
    }
}