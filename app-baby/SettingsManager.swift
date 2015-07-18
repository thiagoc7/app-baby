//
//  SettingsManager.swift
//  app-baby
//
//  Created by Yescas, Francisco on 7/15/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class SettingsManager: NSObject {
    
    let store = NSUserDefaults.standardUserDefaults()
    
    var nextTimerIn: Double = 10800.0 {
        didSet {
            store.setObject(nextTimerIn, forKey: "nextTimerIn")
            store.synchronize()
            
            if nextTimerIn == 0.0 {
                nextTimerReminder = false
            }
        }
    }
    
    var nextTimerReminder: Bool = false {
        didSet {
            store.setObject(nextTimerReminder, forKey: "nextTimerReminder")
            store.synchronize()
        }
    }
    
    var eachBreastReminder: Double = 900.0 {
        didSet {
            store.setObject(eachBreastReminder, forKey: "eachBreastReminder")
            store.synchronize()
        }
    }
    
    var totalTimeReminder: Double = 1800.0 {
        didSet {
            store.setObject(totalTimeReminder, forKey: "totalTimeReminder")
            store.synchronize()
        }
    }
    
    var nextTimerInString: String {
        return timeToString(nextTimerIn)
    }
    
    var eachBreastReminderString: String {
        return timeToString(eachBreastReminder)
    }
    
    var totalTimeReminderString: String {
        return timeToString(totalTimeReminder)
    }
    
    func timeToString (time: Double) -> String {
        if time == 0.0 {
            return "none"
        } else {
            let formatter = NSDateComponentsFormatter()
            formatter.unitsStyle = .Short
            return formatter.stringFromTimeInterval(time)!
        }
    }
    
    override init () {
        super.init()
        
        if let nextTimerIn = store.objectForKey("nextTimerIn") as? Double {
            self.nextTimerIn = nextTimerIn
        }
        
        if let nextTimerReminder = store.objectForKey("nextTimerReminder") as? Bool {
            self.nextTimerReminder = nextTimerReminder
        }
        
        if let eachBreastReminder = store.objectForKey("eachBreastReminder") as? Double {
            self.eachBreastReminder = eachBreastReminder
        }
        
        if let totalTimeReminder = store.objectForKey("totalTimeReminder") as? Double {
            self.totalTimeReminder = totalTimeReminder
        }
        
    }
    
}