//
//  BaseApi.swift
//  on the map
//
//  Created by Ian Gristock on 01/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import Foundation

protocol HttpClient {
    func getBaseUrl() -> String
}

class RestClient : NSObject, HttpClient{
    
    // Session object
    var session: NSURLSession
    var headers: [String:AnyObject] = ["application/json": ["Accept","Content-Type"]]
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func get(#endPoint:String, param:[String:AnyObject]? = nil, range: Int? = nil, success:(Int, [String : AnyObject]?) -> () = {_,_ in}, failure:(String) -> () = {_ in}) {
        executeRequest("GET", endPoint: endPoint, parameters: param, range: range, success: success, failure: failure)
    }
    
    func put(#endPoint:String, param:[String:AnyObject]? = nil, range: Int? = nil, success:(Int, [String : AnyObject]?) -> () = {_,_ in}, failure:(String) -> () = {_ in}) {
        executeRequest("PUT", endPoint: endPoint, parameters: param,  range: range,success: success, failure: failure)
    }
    
    func post(#endPoint:String, param:[String:AnyObject]? = nil,range: Int? = nil, success:(Int, [String : AnyObject]?) -> () = {_,_ in}, failure:(String) -> () = {_ in}) {
        executeRequest("POST", endPoint: endPoint, parameters: param,range: range, success: success, failure: failure)
    }
    
    func delete(#endPoint:String, param:[String:AnyObject]? = nil,range: Int?, success:(Int, [String : AnyObject]?) -> () = {_,_ in}, failure:(String) -> () = {_ in}) {
        executeRequest("DELETE", endPoint: endPoint, parameters: param, range: range, success: success, failure: failure)
    }
    
    func executeRequest(verb: String!, endPoint: String, parameters: [String:AnyObject]? , range: Int?, success:(Int, [String : AnyObject]?) -> (), failure:(String) -> ()) {
        
        let urlString = "\(getBaseUrl())\(endPoint)"
        println(urlString)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = verb
        // build up the headers
        for (key, field) in headers {
            
            // check if it is a flat key pair
            if let str = field as?String {
                request.addValue(key, forHTTPHeaderField: str)
            }
            //check if the value is a dict
            if let array = field as? NSArray {
                for (value) in array {
                    request.addValue(key, forHTTPHeaderField: value as! String)
                }
            }
        }
        if parameters != nil {
            // Generate the body using the passed json body
            request.HTTPBody  = NSJSONSerialization.dataWithJSONObject(parameters!, options: nil, error: nil)
        }
        // Send request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Network error
                failure("Unable to connect to the network")
                return
            }
            var responseData: NSData
            if let dataRange = range as Int! {
               responseData = data.subdataWithRange(NSMakeRange(dataRange, data.length - dataRange)) /* subset response data! */
            }else {
                responseData = data
            }
            let json = NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments, error: nil) as? [String : AnyObject]
            let statusCode = (response as! NSHTTPURLResponse).statusCode

            success(statusCode, json)
        }
        task.resume()
    }
    
    func getBaseUrl() ->String {
        fatalError("Cannot impliment get base url in base class");
    }
    
}

extension RestClient {
    
    struct HTTPResponseCodes {
       static let OK = 200
       static let BAD_CREDENTIALS = 403
       static let FATAL = 500
    }
}