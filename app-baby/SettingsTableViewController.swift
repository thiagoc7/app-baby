//
//  SettingsTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/14/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: Outlets ans vars
    
    @IBOutlet weak var nextTimerInLabel: UILabel!
    @IBOutlet weak var reminderForEachLabel: UILabel!
    @IBOutlet weak var reminderForTotalLabel: UILabel!
    
    var nextTimerIn: Double = 10800.0 {
        didSet {
            nextTimerInLabel.text = formatTime(nextTimerIn)
            store.setObject(nextTimerIn, forKey: "nextTimeDelay")
        }
    }
    
    var eachBreastReminder: Double = 900.0 {
        didSet {
            if eachBreastReminder > 0.0 {
                reminderForEachLabel.text = formatTime(eachBreastReminder)
            } else {
                reminderForEachLabel.text = "none"
            }
        }
    }

    var totalTimeReminder: Double = 1800.0 {
        didSet {
            if totalTimeReminder > 0.0 {
                reminderForTotalLabel.text = formatTime(totalTimeReminder)
            } else {
                reminderForTotalLabel.text = "none"
            }
        }
    }

    
    
    let store = NSUserDefaults.standardUserDefaults()
    
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if store.objectForKey("nextTimeDelay") != nil {
            nextTimerIn = store.objectForKey("nextTimeDelay") as! Double
        }
        
        if store.objectForKey("eachBreastReminder") != nil {
            eachBreastReminder = store.objectForKey("eachBreastReminder") as! Double
        }
        
        if store.objectForKey("totalTimeReminder") != nil {
            totalTimeReminder = store.objectForKey("totalTimeReminder") as! Double
        }

    }
    
    
    // MARK: UI Actions
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextTimerAlarmSwitch(sender: UISwitch) {
                let switchStatus = sender.on
                print(switchStatus)
    }
    
    
    //MARK: Helpers
    
    func formatTime(seconds: Double) -> (String) {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Short
        return formatter.stringFromTimeInterval(seconds)!
    }
    
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toView = segue.destinationViewController as! PickerViewController
        toView.senderTimer = segue.identifier
        
        if segue.identifier == "totalTime" {
            toView.seconds = totalTimeReminder
        } else if segue.identifier == "eachBreast" {
            toView.seconds = eachBreastReminder
        } else if segue.identifier == "nextTimer" {
            toView.seconds = nextTimerIn
            toView.segmentTitles = ["2:00 hs", "2:30 hs", "3:00 hs", "4:00 hs"]
            toView.segmentOptions = [7200, 9000, 10800, 14400]
        }
    }
    
    @IBAction func unwindToPicker(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? PickerViewController {
            let senderTimer = sourceViewController.senderTimer
            let seconds = sourceViewController.seconds
            if senderTimer == "nextTimer" {
                nextTimerIn = seconds
            } else if senderTimer == "eachBreast" {
                eachBreastReminder = seconds
            } else if senderTimer == "totalTime" {
                totalTimeReminder = seconds
            }
        }
    }
    
}
