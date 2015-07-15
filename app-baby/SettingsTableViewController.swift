//
//  SettingsTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/14/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, PickerViewControllerDelegate {
    
    // MARK: Outlets ans vars
    
    @IBOutlet weak var nextTimerInLabel: UILabel!
    @IBOutlet weak var reminderForEachLabel: UILabel!
    @IBOutlet weak var reminderForTotalLabel: UILabel!
    
    var settings = SettingsManager()
    
    var identifier = String()
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }
    
    func updateSeconds(seconds: Double){
        if identifier == "totalTime" {
            settings.totalTimeReminder = seconds
        } else if identifier == "eachBreast" {
            settings.eachBreastReminder = seconds
        } else if identifier == "nextTimer" {
            settings.nextTimerIn = seconds
        }
        updateLabels()
    }
    
    func updateLabels () {
        nextTimerInLabel.text = settings.nextTimerInString
        reminderForEachLabel.text = settings.eachBreastReminderString
        reminderForTotalLabel.text = settings.totalTimeReminderString
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
        toView.delegate = self
        identifier = segue.identifier!
        if segue.identifier == "totalTime" {
            toView.seconds = settings.totalTimeReminder
        } else if segue.identifier == "eachBreast" {
            toView.seconds = settings.eachBreastReminder
        } else if segue.identifier == "nextTimer" {
            toView.seconds = settings.nextTimerIn
            toView.segmentTitles = ["2:00 hs", "2:30 hs", "3:00 hs", "4:00 hs"]
            toView.segmentOptions = [7200, 9000, 10800, 14400]
        }
    }
    
}
