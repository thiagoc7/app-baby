//
//  TimerManager.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/16/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit
import RealmSwift

protocol TimerManagerDelagate {
    func updateLeftTimerLabel(text: String)
    func updateRightTimerLabel(text: String)
    func updateStartTimerLabel(text: String)
    func updateLeftAndRightIcon(update: Bool)
    func updateNextTimeCell(timer: Timer)
    func updateLastTimeCell()
}

class TimerManager: NSObject {
    
    // MARK: Own Properties
    
    let realm = Realm()
    let store = NSUserDefaults.standardUserDefaults()
    
    var timer = Timer()
    var nextTimeCellUpdaterTimerObject = NSTimer()
    var leftTimerObject = NSTimer()
    var rightTimerObject = NSTimer()
    
    var delegate: TimerManagerDelagate!
    
    
    // MARK: Properties Observers
    
    var isRunning = false {        
        didSet {
            var timeLabel = "-- --"
            if isRunning {
                timer.startTime = NSDate()
                timeLabel = timer.startTimeHourString
                
                nextTimeCellUpdaterTimerObject = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("updateNextTimeCell"), userInfo: nil, repeats: true)
        
                store.setObject(timer.startTime, forKey: "startTime")
                store.synchronize()
            } else {
                nextTimeCellUpdaterTimerObject.invalidate()
            }
            delegate?.updateStartTimerLabel(timeLabel)
            updateNextTimeCell()
        }
    }
    
    var leftTimerRunning: Bool = false {
        didSet {
            
            if leftTimerRunning {
                leftTimerObject = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateLeftTimer"), userInfo: nil, repeats: true)
                
                timer.leftIsTheLast = true
                delegate?.updateLeftAndRightIcon(timer.leftIsTheLast)
                
                if !isRunning {
                    isRunning = true
                }
            } else {
                leftTimerObject.invalidate()
                delegate?.updateLeftTimerLabel("00:00")
            }
        }
    }
    
    var rightTimerRunning: Bool = false {
        didSet {
            if rightTimerRunning {
                rightTimerObject = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateRightTimer"), userInfo: nil, repeats: true)
                
                timer.leftIsTheLast = false
                
                delegate?.updateLeftAndRightIcon(timer.leftIsTheLast)
                
                if !isRunning {
                    isRunning = true
                }
                
            } else {
                rightTimerObject.invalidate()
                delegate?.updateRightTimerLabel("00:00")
            }
        }
    }
    
    
    // MARK: Methods
    
    func saveCurrentTimer () {
        if isRunning {
            realm.write {
                self.realm.add(self.timer)
                self.timer = Timer()
            }
            isRunning = false
            leftTimerRunning = false
            rightTimerRunning = false
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
    
    func reset() {
        saveCurrentTimer()
        setInitialScreen()
    }
    
    func setInitialScreen() {
        delegate?.updateLastTimeCell()
        updateNextTimeCell()
    }
    
    func updateNextTimeCell() {
        let storedTimerObject = realm.objects(Timer).last
        let currentTimerObject = self.timer
        
        if self.isRunning == true || (storedTimerObject == nil){
            delegate?.updateNextTimeCell(currentTimerObject)
        } else {
            delegate?.updateNextTimeCell(storedTimerObject!)
        }
    }
    
    
    // MARK: Background
    
    func resumeLeftTimer(seconds: Double, backgroundTime: NSDate) {
        timer.leftTimerSeconds = seconds + NSDate().timeIntervalSinceDate(backgroundTime)
        delegate?.updateLeftTimerLabel(timer.leftTimerSecondsString)
        leftTimerRunning = true
    }
    
    func resumeRightTimer(seconds: Double, backgroundTime: NSDate) {
        timer.rightTimerSeconds = seconds + NSDate().timeIntervalSinceDate(backgroundTime)
        delegate?.updateRightTimerLabel(timer.rightTimerSecondsString)
        rightTimerRunning = true
    }
    
    func applicationDidBecomeActive() {
        if let background  = store.objectForKey("background") as? Bool  {
            
            if let leftIsTheLast = store.objectForKey("leftIsTheLast") as? Bool {
                timer.leftIsTheLast = leftIsTheLast
                store.removeObjectForKey("leftIsTheLast")
            }
            
            if let backgroundTime = store.objectForKey("backgroundTime") as? NSDate {
                
                if let leftTimerSeconds = store.objectForKey("leftTimerSeconds") as? Double {
                    resumeLeftTimer(leftTimerSeconds, backgroundTime: backgroundTime)
                    store.removeObjectForKey("leftTimerSeconds")
                }
                
                if let rightTimerSeconds = store.objectForKey("rightTimerSeconds") as? Double {
                    resumeRightTimer(rightTimerSeconds, backgroundTime: backgroundTime)
                    store.removeObjectForKey("rightTimerSeconds")
                }
                
                if let startTime = store.objectForKey("startTime") as? NSDate {
                    timer.startTime = startTime
                    store.removeObjectForKey("startTime")
                }
                
                store.removeObjectForKey("backgroundTime")
            }
            
            store.removeObjectForKey("background")
        }
    }
    
    func applicationWillResignActive() {
        if isRunning {
            store.setObject(true, forKey: "background")
            store.setObject(timer.leftIsTheLast, forKey: "leftIsTheLast")
            store.setObject(NSDate(), forKey: "backgroundTime")
            store.setObject(timer.startTime, forKey: "startTime")
            
            if leftTimerRunning {
                leftTimerRunning = false
                store.setObject(timer.leftTimerSeconds, forKey: "leftTimerSeconds")
            }
            
            if rightTimerRunning {
                rightTimerRunning = false
                store.setObject(timer.rightTimerSeconds, forKey: "rightTimerSeconds")
            }
            store.synchronize()
        }
    }
}