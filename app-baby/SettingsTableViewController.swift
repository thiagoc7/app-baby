//
//  SettingsTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/14/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var nextTimerInLabel: UILabel!
    @IBOutlet weak var reminderForEachLabel: UILabel!
    @IBOutlet weak var reminderForTotalLabel: UILabel!
    
    
    // MARK: Init
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: Alerts
    
    // var alertController: UIAlertController?
    
    
    // MARK: UI Actions
    
    @IBAction func nextTimer(sender: UITapGestureRecognizer) {
        let controller = UIAlertController(title: "Reminde me in", message:nil, preferredStyle: .ActionSheet)
        
        let set5min = UIAlertAction(title: "5 min", style: .Default, handler: nil)
        let set10min = UIAlertAction(title: "10 min", style: .Default, handler: nil)
        
        let setNoReminde = UIAlertAction(title: "None", style: .Default, handler: nil)
        let setCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        controller.addAction(set5min)
        controller.addAction(set10min)
        controller.addAction(setNoReminde)
        controller.addAction(setCancel)
        
        controller.view.tintColor = UIColor.lightGrayColor()

        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextTimerAlarmSwitch(sender: UISwitch) {
                let switchStatus = sender.on
                print(switchStatus)
    }
    
    @IBAction func eachBreast(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func totalTime(sender: UITapGestureRecognizer) {
    }
    
}
