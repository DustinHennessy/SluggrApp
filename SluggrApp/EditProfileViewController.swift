//
//  EditProfileViewController.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/24/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet var profileTableView :UITableView!
    var dynamicLabelArray = ["First Name", "Last Name", "Home Address", "Work Address", "Morning Depart Time", "Evening Depart Time", "Driver Status","Bio", "Preferences", "Your Map"]
    var dataFieldTypeArray = ["TextFieldCell", "TextFieldCell", "TextFieldCell", "TextFieldCell", "LabelCell", "LabelCell", "SwitchCell","TextViewCell", "TextViewCell", "MapCell"]
    var tapped = false
    let userManager = CurrentUserManager.sharedInstance
    var homeAddress = ""
    var workAddress = ""
    var dateValue :String!
    var mornDeptTime :String!
    var mDeptTime :String!
    var driverStatus :String!
    var userFirstName = ""
    var userLastName = ""
    var userEmail :String!
    var userInputBio = ""
    var userInputPref = ""
    
    
    //#2 geocode the home and work locations so we can annotate on the profileMapView
    
    //MARK: - Table Views
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicLabelArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currentCellType = dataFieldTypeArray[indexPath.row];
        switch currentCellType {
        case "TextViewCell":
            return 120
        case "MapCell":
            return 180
        case "DateCell":
            return 200
        default:
            return 45
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = profileTableView.cellForRowAtIndexPath(indexPath)
        if cell is ProfileLabelTableViewCell {
            let tfCell = cell as! ProfileLabelTableViewCell
            if tfCell.dynamicLCLabel.text == "Morning Depart Time" || tfCell.dynamicLCLabel.text == "Evening Depart Time" {
                let nextIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                var nextCell = profileTableView.cellForRowAtIndexPath(nextIndexPath)
                if nextCell is ProfileDateTableViewCell {
                    dynamicLabelArray.removeAtIndex(indexPath.row + 1)
                    dataFieldTypeArray.removeAtIndex(indexPath.row + 1)
                    let tdCell = nextCell as! ProfileDateTableViewCell
                    tdCell.cellDatePicker.hidden = true
                    profileTableView.deleteRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
                } else {
                    dynamicLabelArray.insert("Start Time", atIndex: indexPath.row + 1)
                    dataFieldTypeArray.insert("DateCell", atIndex: indexPath.row + 1)
                    profileTableView.insertRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                }
                // FIX THIS
                profileTableView.reloadRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        println("TVC")
        let dataFieldPosition = textView.convertPoint(CGPointZero, toView: profileTableView)
        var indexPath = profileTableView.indexPathForRowAtPoint(dataFieldPosition)
        var cell = profileTableView.cellForRowAtIndexPath(indexPath!)
        if cell is ProfileTextViewTableViewCell {
            let sCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextViewTableViewCell
            if sCell.dynamicTVCLabel.text == "Bio" {
                userInputBio = sCell.dynamicTextView.text
                println("\(userInputBio)")
            } else if sCell.dynamicTVCLabel.text == "Preferences" {
                userInputPref = sCell.dynamicTextView.text
                println("\(userInputPref)")
            }
        }
    }
    
    func tableFieldChanged(sender: AnyObject) {
        let dataFieldPosition = sender.convertPoint(CGPointZero, toView: profileTableView)
        var indexPath = profileTableView.indexPathForRowAtPoint(dataFieldPosition)
        var cell = profileTableView.cellForRowAtIndexPath(indexPath!)
        if cell is ProfileTextFieldTableViewCell {
            let sCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextFieldTableViewCell
            if sCell.dynamicTFCLabel.text == "Home Address" {
                if sCell.dynamicProfileTextField != nil {
                    homeAddress = sCell.dynamicProfileTextField.text
                }
            }
            if sCell.dynamicTFCLabel.text == "Work Address" {
                if sCell.dynamicProfileTextField != nil {
                    workAddress = sCell.dynamicProfileTextField.text
                }
            }
            if sCell.dynamicTFCLabel.text == "First Name" {
                userFirstName = sCell.dynamicProfileTextField.text
            }
            if sCell.dynamicTFCLabel.text == "Last Name" {
                userLastName = sCell.dynamicProfileTextField.text
            }
        }
        if cell is ProfileTextViewTableViewCell {
            let tvCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextViewTableViewCell
            if tvCell.dynamicTVCLabel.text == "Bio" {
                userInputBio = tvCell.dynamicTextView.text
            }
            if tvCell.dynamicTVCLabel.text == "Preferences" {
                userInputPref = tvCell.dynamicTextView.text
            }
        }

        if cell is ProfileDateTableViewCell {
            let dCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileDateTableViewCell
            indexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            let lCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileLabelTableViewCell
            lCell.dynamicLCDetailLabel.text = formatDate(dCell.cellDatePicker.date)
            mDeptTime = formatDate(dCell.cellDatePicker.date)
        }
        if cell is ProfileSwitchTableViewCell {
            let swCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileSwitchTableViewCell
            if swCell.cellSwitch == false {
                driverStatus = "No"
            } else {
                driverStatus = "Yes"
            }
        }
    }
    
    func formatDate(date: NSDate) -> String {
        var dateFormatter :NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d @ h:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCellType = dataFieldTypeArray[indexPath.row];
        switch currentCellType {
        case "TextFieldCell":
            println("**** THC Current User @ TFC *** \(userManager.currentUser) \(userManager.currentUser?.userLastName)  \(userManager.currentUser?.userBio)")
            
            var textFieldCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileTextFieldTableViewCell
            textFieldCell.dynamicTFCLabel.text = dynamicLabelArray[indexPath.row]
            if textFieldCell.dynamicTFCLabel.text == "First Name" {
                if userManager.currentUser?.userFirstName != nil {
                    textFieldCell.dynamicProfileTextField.text = userManager.currentUser?.userFirstName
                    userFirstName = textFieldCell.dynamicProfileTextField.text
                }
                
            } else if textFieldCell.dynamicTFCLabel.text == "Last Name" {
                textFieldCell.dynamicProfileTextField.text = userManager.currentUser?.userLastName
                userLastName = textFieldCell.dynamicProfileTextField.text
            } else if textFieldCell.dynamicTFCLabel.text == "Home Address" {
                textFieldCell.dynamicProfileTextField.text = userManager.currentUser?.userHomeLocale
                homeAddress = textFieldCell.dynamicProfileTextField.text
            } else if textFieldCell.dynamicTFCLabel.text == "Work Address" {
                textFieldCell.dynamicProfileTextField.text = userManager.currentUser?.userWorkLocale
                workAddress = textFieldCell.dynamicProfileTextField.text
            }
            textFieldCell.selectionStyle = UITableViewCellSelectionStyle.None
            textFieldCell.dynamicProfileTextField.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
            return textFieldCell
        case "LabelCell":
            var labelCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileLabelTableViewCell
            labelCell.dynamicLCLabel.text = dynamicLabelArray[indexPath.row]
            if labelCell.dynamicLCLabel.text == "Morning Depart Time" {
                labelCell.dynamicLCDetailLabel.text = userManager.currentUser?.userMorningTime
            } else if labelCell.dynamicLCLabel.text == "Evening Depart Time" {
                labelCell.dynamicLCDetailLabel.text = userManager.currentUser?.userEveningTime
            } else {
                labelCell.dynamicLCDetailLabel.text = formatDate(NSDate())
            }
            labelCell.selectionStyle = UITableViewCellSelectionStyle.None
            return labelCell
        case "SwitchCell":
            var switchCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileSwitchTableViewCell
            switchCell.dynamicSCLabel.text = dynamicLabelArray[indexPath.row]
            if userManager.currentUser?.driverStatus == true {
                switchCell.cellSwitch.setOn(true, animated: false)
            } else {
                switchCell.cellSwitch.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
            }
            switchCell.selectionStyle = UITableViewCellSelectionStyle.None
            return switchCell
        case "TextViewCell":
            println("**** THC Current User @ TVC *** \(userManager.currentUser) \(userManager.currentUser?.userLastName) \(userManager.currentUser?.userBio)")
            var textViewCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileTextViewTableViewCell
            textViewCell.dynamicTVCLabel.text = dynamicLabelArray[indexPath.row]
            if textViewCell.dynamicTVCLabel.text == "Bio" {
                textViewCell.dynamicTextView.text = userManager.currentUser?.userBio
                userInputBio = textViewCell.dynamicTextView.text
            } else if textViewCell.dynamicTVCLabel.text == "Preferences" {
                textViewCell.dynamicTextView.text = userManager.currentUser?.userPreferences
                userInputPref = textViewCell.dynamicTextView.text
            }
            textViewCell.dynamicTextView.delegate = self
            textViewCell.selectionStyle = UITableViewCellSelectionStyle.None
            return textViewCell
        case "MapCell":
            var mapViewCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileMapTableViewCell
            mapViewCell.selectionStyle = UITableViewCellSelectionStyle.None
            return mapViewCell
        case "DateCell":
            var dateViewCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileDateTableViewCell
            dateViewCell.cellDatePicker.hidden = false
            // SET DATE HERE
            dateViewCell.cellDatePicker.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
            dateViewCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return dateViewCell
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    
    //MARK: - Data to API
    
    @IBAction func saveDataToAPI(sender: UIBarButtonItem) {
        println("SDTA Start")
        
        //creating the request
        let url = NSURL(string: "http://sluggr-api.herokuapp.com/demo_user/edit_ios")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        println("\(userManager.currentUser!.userEmail)")
        println("\(userFirstName)")
        println("\(userLastName)")
        println("\(homeAddress)")
        println("\(workAddress)")
        println("\(userInputPref)")
        println("\(userInputBio)")
        
        request.setValue("\(userManager.currentUser!.userEmail)", forHTTPHeaderField: "email")
        request.setValue("\(homeAddress)", forHTTPHeaderField: "home_locale")
        request.setValue("\(workAddress)", forHTTPHeaderField: "work_locale")
        request.setValue("\(userInputBio)", forHTTPHeaderField: "bio")
        request.setValue("\(userInputPref)", forHTTPHeaderField: "preferences")
        request.setValue("\(userFirstName)", forHTTPHeaderField: "first_name")
        request.setValue("\(userLastName)", forHTTPHeaderField: "last_name")
        
        
        //firing the request
        if count(userFirstName) != 0 {
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                println("error: \(error)")
                var err: NSError
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                //            let usersDictArray = jsonResult.objectForKey("users") as! [NSDictionary]
                //            for userDict in usersDictArray {
                //                let user = Users()
                
                println("\(jsonResult)")
            })
        } else {
            let alertController = UIAlertController(title: "First name missing", message: "You need to include a first name before you can continue.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                println(action)
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                println(action)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        println("SDTA End")
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("**** THC Current User @ Profile *** \(userManager.currentUser)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
