//
//  StudentLocationTableViewController.swift
//  on the map
//
//  Created by Ian Gristock on 06/09/2015.
//  Copyright (c) 2015 Ian Gristock. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: UITableViewController {

    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getStudentLocations")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: "onMarkerDrop:")
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        getStudentLocations()
        
    }
    
    func getStudentLocations() {
        SwiftSpinner.show("Fetching Student Locations ...")
        StudentLocationReposiotry.sharedInstance().getStudentLocations(
            {
                responseCode, studentLocations in
                
                if let studentLocations = studentLocations as [StudentLocation]! {
                    
                    self.studentLocations = studentLocations
                    
                    // Add the annotations to the map, need to be on the main thread to appear directly
                    dispatch_async(dispatch_get_main_queue(),{
                        SwiftSpinner.hide()
                        self.tableView.reloadData()
                    });
                    
                }
                
            },
            errorHandler: {
                errorMessage in
            }
        )

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return studentLocations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "\(studentLocations[indexPath.row].fullName!)"
        cell.detailTextLabel?.text = "\(studentLocations[indexPath.row].mapString!)"

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: studentLocations[indexPath.row].mediaURL!)!)
    }

}
