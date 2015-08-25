//
//  LoginViewController.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/24/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var fieldArray = ["Email", "First Name", "Username", "Password"]
    @IBOutlet var loginTableView :UITableView!
    var emailField :String!
    var passwordField :String!
    var usernameField :String!
    var firstNameField :String!
    @IBOutlet var registerButton :UIButton!
    let userManager = CurrentUserManager.sharedInstance
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell :ProfileTextFieldTableViewCell = tableView.dequeueReusableCellWithIdentifier("rlcell") as! ProfileTextFieldTableViewCell
        //        let currentUser = userArray[indexPath.row]
        cell.dynamicTFCLabel.text = fieldArray[indexPath.row]
        cell.dynamicProfileTextField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        tableView.scrollEnabled = false
        
        
        return cell
        
    }
    
    func textFieldChanged(sender: AnyObject) {
        let dataFieldPosition = sender.convertPoint(CGPointZero, toView: loginTableView)
        println("TFC1")
        let indexPath = loginTableView.indexPathForRowAtPoint(dataFieldPosition)
        println("TFC2")
        let cell = loginTableView.cellForRowAtIndexPath(indexPath!)
        if cell is ProfileTextFieldTableViewCell {
            println("TFC3")
            let sCell = loginTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextFieldTableViewCell
            if sCell.dynamicTFCLabel.text == "Email" {
                if sCell.dynamicProfileTextField != nil {
                    emailField = sCell.dynamicProfileTextField.text
                    println("TFC4")
                    println("\(emailField)")
                }
            }
            if sCell.dynamicTFCLabel.text == "First Name" {
                if sCell.dynamicProfileTextField != nil {
                    firstNameField = sCell.dynamicProfileTextField.text
                }
            }
            if sCell.dynamicTFCLabel.text == "Username" {
                if sCell.dynamicProfileTextField != nil {
                    usernameField = sCell.dynamicProfileTextField.text
                }
            }
            if sCell.dynamicTFCLabel.text == "Password" {
                if sCell.dynamicProfileTextField != nil {
                    passwordField = sCell.dynamicProfileTextField.text
                }
            }
        }
    }
    
    
    @IBAction func LoginUser(sender: UIButton){
        
        let url = NSURL(string: "http://sluggr-api.herokuapp.com")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        println("ZZZZZZZZZZZ: \(emailField)")
        request.setValue("\(emailField)", forHTTPHeaderField: "email")
        request.setValue("\(passwordField)", forHTTPHeaderField: "password")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            println("error: \(error)")
            if error == nil {
                var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
                println("Data: \(dataString)")
                var err: NSError?
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                var userDict = jsonResult.objectForKey("user") as! NSDictionary
                var userDict2 = jsonResult.objectForKey("itinerary") as! NSDictionary
                var currentUser = Users()
                if userDict.objectForKey("first_name") != nil {
                    currentUser.userFirstName = userDict.objectForKey("first_name") as! String
                }
                if userDict.objectForKey("last_name") != nil {
                    currentUser.userLastName = userDict.objectForKey("last_name") as? String
                }
                currentUser.userEmail = userDict.objectForKey("email") as! String
                currentUser.userID = userDict.objectForKey("id") as? Int
                currentUser.username = userDict.objectForKey("username") as? String
                currentUser.userPreferences = userDict.objectForKey("preferences") as? String
                currentUser.userBio = userDict.objectForKey("bio") as? String
                //Using UserDict2 here because the api returns a dictionary with two seperate dictionaries of results.
                currentUser.userHomeLocale = userDict2.objectForKey("home_locale") as? String
                currentUser.userWorkLocale = userDict2.objectForKey("work_locale") as? String
                currentUser.userMorningTime = userDict2.objectForKey("morning_time") as? String
                currentUser.userEveningTime = userDict2.objectForKey("evening_time") as? String
                
                self.userManager.currentUser = currentUser
                println("\(jsonResult)")
                
            } else {
                self.userManager.currentUser = nil
            }
            println("**** THC Current User @ Login *** \(self.userManager.currentUser)")
            self.navigationController!.popToRootViewControllerAnimated(true)
        })
        
        
    }
    
    @IBAction func signUpUser(sender: UIBarButtonItem){
        
        let url = NSURL(string: "http://sluggr-api.herokuapp.com/demo_user/create_ios")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        println("ZZZZZZZZZZZ: \(emailField)")
        println("BBBBBBBBB: \(passwordField)")
        println("DDDDDDDD: \(firstNameField)")
        println("EEEEEEEE: \(usernameField)")
        
        
        request.setValue("\(emailField)", forHTTPHeaderField: "email")
        request.setValue("\(passwordField)", forHTTPHeaderField: "password")
        request.setValue("\(firstNameField)", forHTTPHeaderField: "first_name")
        request.setValue("\(usernameField)", forHTTPHeaderField: "username")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            println("error: \(error)")
            var err: NSError
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            println("\(jsonResult)")
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGrayColor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("VDL")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
