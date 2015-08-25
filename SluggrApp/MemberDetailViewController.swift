//
//  MemberDetailViewController.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/24/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit
import MessageUI

class MemberDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var memberDetailTableView :UITableView!
    var selectedUser :Users!
    var currentUser :Users!
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let nCell :MemberNameTableViewCell = tableView.dequeueReusableCellWithIdentifier("nameCell") as! MemberNameTableViewCell
            if selectedUser?.userLastName != nil {
                nCell.memberFullNameLabel.text = selectedUser.userFirstName! + " " + selectedUser.userLastName!
            } else {
                nCell.memberFullNameLabel.text = selectedUser.userFirstName
            }
            nCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return nCell
        case 1:
            let eCell :MemberEmailTableViewCell = tableView.dequeueReusableCellWithIdentifier("emailCell") as! MemberEmailTableViewCell
            if selectedUser?.userEmail != nil {
                eCell.emailAddressLabel.text = selectedUser?.userEmail
            }
            eCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return eCell
        case 2:
            let tCell :MemberTravelTableViewCell = tableView.dequeueReusableCellWithIdentifier("travelCell") as! MemberTravelTableViewCell
            tCell.dynamicDepartLabel.text = "Home Locale:"
            if selectedUser?.userHomeLocale != nil {
                tCell.dynamicDetailDepartLabel.text = selectedUser?.userHomeLocale
            }
            tCell.dynamicDestLabel.text = "Work Locale:"
            if selectedUser?.userWorkLocale != nil {
                tCell.dynamicDetailDestLabel.text = selectedUser?.userWorkLocale
            }
            tCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return tCell
        case 3:
            let bCell :ProfileTextViewTableViewCell = tableView.dequeueReusableCellWithIdentifier("textViewCell") as! ProfileTextViewTableViewCell
            bCell.dynamicTVCLabel.text = "Bio:"
            if selectedUser?.userBio != nil {
                bCell.dynamicTextView.text = selectedUser?.userBio
            }
            bCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return bCell
        case 4:
            let pCell :ProfileTextViewTableViewCell = tableView.dequeueReusableCellWithIdentifier("textViewCell") as! ProfileTextViewTableViewCell
            pCell.dynamicTVCLabel.text = "Preferences:"
            pCell.dynamicTextView.text = selectedUser?.userPreferences
            pCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return pCell
            
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    
    @IBAction func emailButtonPressed(sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setSubject("Subject goes here")
            mailController.setMessageBody("Hi, I'm happy to rideshare with you. The best place to pick me up is...", isHTML: false)
            if let userEmail = selectedUser?.userEmail {
                mailController.setToRecipients([userEmail])
            } else {
                println("Nil")
            }
            presentViewController(mailController, animated: true, completion: nil)
        }
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllers()
    }
    
    func dismissViewControllers(){
        self.becomeFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        println("**** Got \(selectedUser.userEmail)")
        memberDetailTableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
