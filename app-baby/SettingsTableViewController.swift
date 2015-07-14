//
//  SettingsTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/14/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

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
}
