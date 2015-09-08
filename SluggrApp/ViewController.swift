//
//  ViewController.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/24/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    var locationManager :CLLocationManager!
    var lastLocation :CLLocation!
    var userArray = [Users]()
    var groupArray = [Users]()
    @IBOutlet var userTableView :UITableView!
    @IBOutlet var mapView :MKMapView!
    let userManager = CurrentUserManager.sharedInstance
    var inviteeID :Int!
    var inviteeName :String!
    var inviteeEmail :String!
    @IBOutlet var segmentedControl :UISegmentedControl!
    var tappedAnnot :CLLocation?
    var toggleIsOn = true
    var barButton2 :UIBarButtonItem!
    var groupRequestCalled = false
    @IBOutlet var editProfileButton :UIBarButtonItem!
    
    
    
    
    
    //MARK: - HTTP Request and basic auth
    
    func getDataFromAPI (){
        println("GDFA Start")
        
        //creating the request
        let url = NSURL(string: "http://sluggr-api.herokuapp.com/data")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let tempEmail = "a@b.com"
        request.setValue("basic \(userManager.currentUser?.userEmail)", forHTTPHeaderField: "email")
        println("Current User Email!!! \(userManager.currentUser?.userEmail)")
        
        //firing the request
        //let urlConnection = NSURLConnection(request: request, delegate: self)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            println("error: \(error)")
            var err: NSError
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            let usersDictArray = jsonResult.objectForKey("users") as! [NSDictionary]
            for userDict in usersDictArray {
                let user = Users()
                if !(userDict.objectForKey("first_name") is NSNull) {
                    user.userFirstName = userDict.objectForKey("first_name") as! String
                }
                user.userLastName = userDict.objectForKey("last_name") as? String
                user.userEmail = userDict.objectForKey("email") as! String
                user.userBio = userDict.objectForKey("bio") as? String
                user.userMorningTime = userDict.objectForKey("morning_time") as? String
                user.userEveningTime = userDict.objectForKey("evening_time") as? String
                user.driverStatus = userDict.objectForKey("driver") as? Bool
                user.userHomeLat = userDict.objectForKey("home_lat") as? Float
                user.userHomeLong = userDict.objectForKey("home_lng") as? Float
                user.userHomeLocale = userDict.objectForKey("home_locale") as? String
                user.userID = userDict.objectForKey("id") as? Int
                user.userPreferences = userDict.objectForKey("preferences") as? String
                user.userWorkLat = userDict.objectForKey("work_lat") as? Float
                user.userWorkLong = userDict.objectForKey("work_lng") as? Float
                user.userWorkLocale = userDict.objectForKey("work_locale") as? String
                user.username = userDict.objectForKey("username") as? String
                
                self.userArray.append(user)
                
            }
            self.userTableView.reloadData()
            //            self.annotatingUsers()
            println("\(jsonResult)")
        })
        println("GDFA End")
        
    }
    
    //MARK: - Nav Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("PFS 1")
        if segue.identifier == "toMemberDetail" {
            println("PFS 2")
            let destController = segue.destinationViewController as! MemberDetailViewController
            let indexPath = userTableView.indexPathForSelectedRow()
            if let unwrappedIndexPath = indexPath {
                let currentUser = groupArray[unwrappedIndexPath.row]
                println("pfs \(currentUser.userFirstName) & \(currentUser.userEmail)")
                destController.selectedUser = currentUser
                userTableView.deselectRowAtIndexPath(unwrappedIndexPath, animated: true)
            }
        }
        
    }
    
    
    func loginButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toLogin", sender: self)
    }
    
    //MARK: - Location Monitoring
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let uLocations = locations {
            lastLocation = uLocations.last as! CLLocation
            zoomToLocationWithLat(lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    func turnOnLocationMonitoring() {
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func prepareLocationMonitoring() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways:
                self.turnOnLocationMonitoring()
            case .AuthorizedWhenInUse:
                self.turnOnLocationMonitoring()
            case .Denied:
                break
            case .NotDetermined:
                print("authorization not determined")
                locationManager.requestAlwaysAuthorization()
                break
            default:
                break
            }
            
        }
        
    }
    
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        tappedAnnot = CLLocation(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude)
        
    }
    
    
    func calculateDistance(sender: UIBarButtonItem) {
        var userLoc = CLLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        if !toggleIsOn {
            for user in userArray {
                var latitude = 0.0
                var longitude = 0.0
                if user.userHomeLat != nil && user.userHomeLong != nil {
                    latitude = Double(user.userHomeLat!)
                    longitude = Double(user.userHomeLong!)
                }
                let location = CLLocation(latitude: latitude, longitude: longitude)
                user.userDistance = userLoc.distanceFromLocation(location)
            }
        } else {
            for user in userArray {
                var latitude = 0.0
                var longitude = 0.0
                if user.userWorkLat != nil && user.userWorkLong != nil {
                    latitude = Double(user.userWorkLat!)
                    longitude = Double(user.userWorkLong!)
                }
                let location = CLLocation(latitude: latitude, longitude: longitude)
                user.userDistance = userLoc.distanceFromLocation(location)
            }
        }
        let barButton1 = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "loginButtonPressed:")
        if !toggleIsOn {
            barButton2 = UIBarButtonItem(image: UIImage(named: "IconSortWork"), style: .Plain, target: self, action: "calculateDistance:")
        } else {
            barButton2 = UIBarButtonItem(image: UIImage(named: "IconSortHome"), style: UIBarButtonItemStyle.Plain, target: self, action: "calculateDistance:")
        }
        let barButtonArray = [barButton1, barButton2]
        toggleIsOn = !toggleIsOn
        navigationItem.setRightBarButtonItems(barButtonArray, animated: true)
        userArray.sort { $0.userDistance < $1.userDistance }
        userTableView.reloadData()
        println("USER LOCATION = \(userLoc)")
        
    }
    
    
    //MARK: - Invite Users
    
    @IBAction func inviteUsers(sender: UIButton) {
        if userManager.currentUser?.userEmail != nil {
            let dataFieldPosition = sender.convertPoint(CGPointZero, toView: userTableView)
            let indexPath = userTableView.indexPathForRowAtPoint(dataFieldPosition)
            let currentInvitee = userArray[indexPath!.row]
            //creating the request
            let url = NSURL(string: "http://sluggr-api.herokuapp.com/invite?rider_id=\(currentInvitee.userID)")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            request.setValue("basic \(userManager.currentUser?.userEmail)", forHTTPHeaderField: "email")
            
            println("user email to be invited **\(userManager.currentUser!.userEmail)")
            println("invitee ID **\(currentInvitee.userID)")
            println("invitee name \(currentInvitee.userFirstName)")
            println("invitee email \(currentInvitee.userEmail)")
            
            //firing the request
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                println("error: \(error)")
                println("response: \(response)")
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("data:\(dataString)")
                
                var err: NSError
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
                println("\(jsonResult)")
                
                let alertController = UIAlertController(title: "Huzzah!", message: "Your invite has been sent!", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                    println(action)
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    
                }
            })
        }
    }
    
    
    //MARK: - Segmented control
    
    @IBAction func segmentedControlPressed(sender: UISegmentedControl) {
        if userManager.currentUser?.userEmail != nil {
            if groupRequestCalled == false {
                if sender.selectedSegmentIndex == 1 {
                    let url = NSURL(string: "http://sluggr-api.herokuapp.com/group")
                    let request = NSMutableURLRequest(URL: url!)
                    request.HTTPMethod = "GET"
                    request.setValue("basic \(userManager.currentUser?.userEmail)", forHTTPHeaderField: "email")
                    
                    //firing the request
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        println("error: \(error)")
                        println("response: \(response)")
                        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("data:\(dataString)")
                        var err: NSError
                        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                        if dataString!.containsString("first_name") {
                            let groupDictArray = jsonResult.objectForKey("group") as! [NSDictionary]
                            for groupDict in groupDictArray {
                                let user = Users()
                                if let groupMemberName = groupDict.objectForKey("first_name") as? String {
                                    println("Member name::::\(groupMemberName)")
                                    user.userFirstName = groupMemberName
                                }
                                if let memberLastName = groupDict.objectForKey("last_name") as? String {
                                    user.userLastName = memberLastName
                                }
                                user.userHomeLocale = groupDict.objectForKey("home_locale") as? String
                                user.userWorkLocale = groupDict.objectForKey("work_locale") as? String
                                user.userEmail = groupDict.objectForKey("email") as! String
                                user.userBio = groupDict.objectForKey("bio") as? String
                                user.userPreferences = groupDict.objectForKey("preferences") as? String
                                user.userMorningTime = groupDict.objectForKey("morning_time") as? String
                                user.userEveningTime = groupDict.objectForKey("evening_time") as? String
                                if groupDict.objectForKey("driver") as? Int == 1 {
                                    user.driverStatus = true
                                } else {
                                    user.driverStatus = false
                                }
                                self.groupArray.append(user)
                            self.groupRequestCalled = true
                            }
                        }
                        println("\(jsonResult)")
                        self.userTableView.reloadData()
                    })
                }
            }
            self.userTableView.reloadData()
            
        } else {
            if segmentedControl.selectedSegmentIndex == 1 {
                let alertController = UIAlertController(title: "Not Logged in", message: "Your must login before you can view your group!", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                    println(action)
                }
                
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    
                }
            }
        }
        
    }
    
    
    //MARK: - Map Methods
    
    func zoomToLocationWithLat(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        println("ZTL Start")
        var zoomLocation = CLLocationCoordinate2D()
        zoomLocation.latitude = latitude
        zoomLocation.longitude = longitude
        var viewRegion :MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 50000, 50000)
        var adjustedRegion :MKCoordinateRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        println("ZTL End")
    }
    
    //MARK: - Map Annotations
    
    func formatDate(date: NSDate) -> String {
        var dateFormatter :NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var locs = [MKPointAnnotation]()
        for annot in mapView.annotations {
            if annot is MKPointAnnotation {
                locs.append(annot as! MKPointAnnotation)
            }
        }
        
        mapView.removeAnnotations(locs)
        
        var pins = [MKPointAnnotation]()
        var tappedUser = Users()
        if segmentedControl.selectedSegmentIndex == 0 {
            tappedUser = userArray[indexPath.row]
        } else {
            tappedUser = groupArray[indexPath.row]
        }
        
        if (tappedUser.userWorkLat != nil && tappedUser.userWorkLong != nil) {
            var wpa = MKPointAnnotation()
            wpa.coordinate = CLLocationCoordinate2DMake(Double(tappedUser.userWorkLat!), Double(tappedUser.userWorkLong!))
            wpa.title = "Work: \(tappedUser.userFirstName) \(tappedUser.userLastName)"
            println("\(tappedUser.userEveningTime)")
            if tappedUser.userEveningTime != nil {
                wpa.subtitle = "Departure time: \(tappedUser.userEveningTime!)"
            }
            println("user first name: \(tappedUser.userFirstName)")
            
            pins.append(wpa)
        }
        if (tappedUser.userHomeLat != nil && tappedUser.userHomeLong != nil) {
            var hpa = MKPointAnnotation()
            hpa.coordinate = CLLocationCoordinate2DMake(Double(tappedUser.userHomeLat!), Double(tappedUser.userHomeLong!))
            hpa.title = "Home: \(tappedUser.userFirstName) \(tappedUser.userLastName)"
            if tappedUser.userEveningTime != nil {
                hpa.subtitle = "Departure time: \(tappedUser.userMorningTime!)"
            }
            pins.append(hpa)
        }
        println("Count: \(pins.count)")
        mapView.addAnnotations(pins)
        println("AU End")
        
        if segmentedControl.selectedSegmentIndex == 1 {
            performSegueWithIdentifier("toMemberDetail", sender: self)
        }
    }
    
    
    
    func annotatingUsers() {
        println("AU Start")
        var locs = [MKPointAnnotation]()
        for annot in mapView.annotations {
            if annot is MKPointAnnotation {
                locs.append(annot as! MKPointAnnotation)
            }
        }
        mapView.removeAnnotations(locs)
        var pins = [MKPointAnnotation]()
        if  let currentUser = userManager.currentUser {
            if (currentUser.userWorkLat != nil && currentUser.userWorkLong != nil) {
                var wpa = MKPointAnnotation()
                wpa.coordinate = CLLocationCoordinate2DMake(Double(currentUser.userWorkLat!), Double(currentUser.userWorkLong!))
                wpa.title = "Work: \(currentUser.userFirstName) \(currentUser.userLastName)"
                println("user first name: \(currentUser.userFirstName)")
                pins.append(wpa)
            }
            if (currentUser.userHomeLong != nil && currentUser.userHomeLat != nil) {
                var hpa = MKPointAnnotation()
                hpa.coordinate = CLLocationCoordinate2DMake(Double(currentUser.userHomeLat!), Double(currentUser.userHomeLong!))
                hpa.title = "Home: \(currentUser.userFirstName) \(currentUser.userLastName)"
                pins.append(hpa)
            }
        }
        println("Count: \(pins.count)")
        mapView.addAnnotations(pins)
        println("AU End")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "pin"
        var aView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if aView == nil {
            aView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            aView!.canShowCallout = true
            
        } else {
            aView!.annotation = annotation
        }
        return aView
        
    }
    
    
    
    //MARK: - Table View Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 120
        case 1:
            return 90
        default:
            return 120
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return userArray.count
        case 1:
            return groupArray.count
        default:
            return userArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell :UserTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UserTableViewCell
            let currentUser = userArray[indexPath.row]
            if currentUser.userFirstName != nil {
                cell.nameLabel.text = currentUser.userFirstName
            }
            cell.destinationLabel.text = currentUser.userWorkLocale
            cell.departureLabel.text = currentUser.userHomeLocale

            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
            
        } else {
            let groupCell :GroupTableViewCell = tableView.dequeueReusableCellWithIdentifier("GroupCell") as! GroupTableViewCell
            if groupArray.count != 0 {
                let currentUser = groupArray[indexPath.row]
                groupCell.groupMemberNameLabel.text = currentUser.userFirstName
                groupCell.departureLabel.text = currentUser.userHomeLocale
                groupCell.destinationLabel.text = currentUser.userWorkLocale
                groupCell.selectionStyle = UITableViewCellSelectionStyle.None
                if currentUser.driverStatus == true {
                    groupCell.driverLabel.text = "D"
                } else {
                    groupCell.driverLabel.text = "R"
                }
            } else {
                //do nothing
            }
            return groupCell
        }
    }
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
        println("VDL END")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareLocationMonitoring()
        annotatingUsers()
        let barButton1 = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "loginButtonPressed:")
        if toggleIsOn {
            barButton2 = UIBarButtonItem(image: UIImage(named: "IconSortWork"), style: .Plain, target: self, action: "calculateDistance:")
        } else {
            barButton2 = UIBarButtonItem(image: UIImage(named: "IconSortHome"), style: UIBarButtonItemStyle.Plain, target: self, action: "calculateDistance:")
        }
        barButton2.tintColor = UIColor.darkGrayColor()
        let barButtonArray = [barButton1, barButton2]
        self.navigationItem.rightBarButtonItems = barButtonArray
        println("VWA END")
        println("**** THC Current User *** \(userManager.currentUser)")
        if userManager.currentUser?.userEmail == nil {
            editProfileButton!.enabled = false
        } else {
            editProfileButton!.enabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



