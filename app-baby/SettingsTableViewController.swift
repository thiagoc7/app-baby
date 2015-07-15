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
            nextTimerInLabel.text = "new time"
        }
    }
    
    var eachBreastReminder: Double = 900.0 {
        didSet {
            let newMinutes = eachBreastReminder / 60
            reminderForEachLabel.text = "\(newMinutes) min"
        }
    }

    var totalTimeReminder: Double = 1800.0 {
        didSet {
            let newMinutes = totalTimeReminder / 60
            reminderForTotalLabel.text = "\(newMinutes) min"
        }
    }

    
    
    let store = NSUserDefaults.standardUserDefaults()
    
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if store.objectForKey("nextTimerIn") != nil {
            nextTimerIn = store.objectForKey("totalTimeReminder") as! Double
        }
        
        if store.objectForKey("eachBreastReminder") != nil {
            eachBreastReminder = store.objectForKey("totalTimeReminder") as! Double
        }
        
        if store.objectForKey("totalTimeReminder") != nil {
            totalTimeReminder = store.objectForKey("totalTimeReminder") as! Double
        }

    }
    
    
    // MARK: UI Actions
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextTimer(sender: UITapGestureRecognizer) {

    }
    
    @IBAction func nextTimerAlarmSwitch(sender: UISwitch) {
                let switchStatus = sender.on
                print(switchStatus)
    }
    
    @IBAction func eachBreast(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func totalTime(sender: UITapGestureRecognizer) {
    }
    
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toView = segue.destinationViewController as! PickerViewController
        
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
    
}
