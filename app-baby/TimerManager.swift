//
//  TimerManager.swift
//  app-baby
//
//  Created by Yescas, Francisco on 7/15/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit
import RealmSwift

protocol TimerManagerDelagate {
    func updateLeftTimerLabel(text: String)
    func updateRightTimerLabel(text: String)
    func updateStartTimerLabel(text: String)
    func updateLeftAndRightIcon(update: Bool)
}

class TimerManager: NSObject {
    
    let realm = Realm()
    let store = NSUserDefaults.standardUserDefaults()
    
    var timer = Timer()
    var leftTimerObject = NSTimer()
    var rightTimerObject = NSTimer()
    
    var delegate:TimerManagerDelagate!
    
    // MARK: Properties Observers
    
    var startTime: NSDate? {
        didSet {
            store.setObject(startTime, forKey: "startTime")
            store.synchronize()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            delegate?.updateStartTimerLabel(dateFormatter.stringFromDate(startTime!))
        }
    }
    
    var isRunning = false {
        didSet {
            if isRunning {
                startTime = NSDate()
            }
        }
    }
    
    var leftTimerRunning: Bool = false {
        didSet {
            if leftTimerRunning {
                leftTimerObject = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateLeftTimer"), userInfo: nil, repeats: true)
                leftIsTheLast = true
                if !isRunning {
                    isRunning = true
                }
            } else {
                leftTimerObject.invalidate()
            }
        }
    }
    
    var rightTimerRunning: Bool = false {
        didSet {
            if rightTimerRunning {
                rightTimerObject = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateRightTimer"), userInfo: nil, repeats: true)
                leftIsTheLast = false
                if !isRunning {
                    isRunning = true
                }
            } else {
                rightTimerObject.invalidate()
            }
        }
    }
    
    var leftIsTheLast: Bool = false {
        didSet {
            delegate?.updateLeftAndRightIcon(leftIsTheLast)
        }
    }
    
    // MARK: Methods
    
    func saveCurrentTimer () {
        if isRunning {
            timer.startTime = startTime!
            timer.leftIsTheLast = leftIsTheLast
            
            realm.write {
                self.realm.add(self.timer)
            }
            
            isRunning = false
            leftTimerRunning = false
            rightTimerRunning = false
            timer = Timer();
        }
    }
    
    func updateLeftTimer() {
        timer.leftTimerSeconds++
        delegate?.updateLeftTimerLabel(timer.leftTimerSecondsString)
    }
    
    func updateRightTimer() {
        timer.rightTimerSeconds++
        delegate?.updateRightTimerLabel(timer.rightTimerSecondsString)
    }
    
    func resumeLeftTimer(seconds: Double, backgroundTime: NSDate) {
        timer.leftTimerSeconds = seconds + NSDate().timeIntervalSinceDate(backgroundTime)
        leftTimerRunning = true
    }
    
    func resumeRightTimer(seconds: Double, backgroundTime: NSDate) {
        timer.rightTimerSeconds = seconds + NSDate().timeIntervalSinceDate(backgroundTime)
        rightTimerRunning = true
    }
    
    func applicationDidBecomeActive() {
        if store.objectForKey("nextTimeDelay") != nil {
            nextTimeDelay = store.objectForKey("nextTimeDelay") as! Double
        }
        
        if store.objectForKey("leftIsTheLast") != nil {
            leftIsTheLast = store.objectForKey("leftIsTheLast") as! Bool
        }
        
        if store.objectForKey("background") != nil {
            let backgroundTime = store.objectForKey("backgroundTime") as! NSDate
            
            if store.objectForKey("leftTimerSeconds") != nil {
                resumeLeftTimer(store.objectForKey("leftTimerSeconds") as! Double, backgroundTime: backgroundTime)
                store.removeObjectForKey("leftTimerSeconds")
            }
            
            if store.objectForKey("rightTimerSeconds") != nil {
                resumeRightTimer(store.objectForKey("rightTimerSeconds") as! Double, backgroundTime: backgroundTime)
                store.removeObjectForKey("rightTimerSeconds")
            }
            
            startTime = store.objectForKey("startTime") as? NSDate
            
            store.removeObjectForKey("startTime")
            store.removeObjectForKey("background")
            store.removeObjectForKey("leftIsTheLast")
        }
    }
    
    func applicationWillResignActive() {
        if isRunning {
            store.setObject(true, forKey: "background")
            store.setObject(NSDate(), forKey: "backgroundTime")
            store.setObject(startTime, forKey: "startTime")
            store.setObject(nextTimeDelay, forKey: "nextTimeDelay")
            
            if leftTimerRunning {
                leftTimerRunning = false
                store.setObject(timer.leftTimerSeconds, forKey: "leftTimerSeconds")
            }
            
            if rightTimerRunning {
                rightTimerRunning = false
                store.setObject(timer.rightTimerSeconds, forKey: "rightTimerSeconds")
            }
        }
    }

   
}
