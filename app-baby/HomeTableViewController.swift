//
//  HomeTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/6/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit
import RealmSwift

var nextTimeDelay: Double = 10800

class HomeTableViewController: UITableViewController {
    
    // MARK: Outlets

    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var nextTime: UILabel!
    @IBOutlet weak var leftTimer: UILabel!
    @IBOutlet weak var rightTimer: UILabel!
    @IBOutlet weak var leftTableCell: UITableViewCell!
    @IBOutlet weak var rightTableCell: UITableViewCell!
    
    
    // MARK: Init
    
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    
    // MARK: Background
    
    let store = NSUserDefaults.standardUserDefaults()
    
    func applicationDidBecomeActive() {
        if store.objectForKey("startTime") != nil {
            startTime = store.objectForKey("startTime") as? NSDate
        }
        
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
            
            store.removeObjectForKey("background")
            store.removeObjectForKey("leftIsTheLast")
        }
    }
    
    func resumeLeftTimer(seconds: Double, backgroundTime: NSDate) {
        leftTimerSeconds = seconds + NSDate().timeIntervalSinceDate(backgroundTime)
        leftTimerRunning = true
    }
    
    func resumeRightTimer(seconds: Double, backgroundTime: NSDate) {
        let addSeconds: Double = 100
        rightTimerSeconds = seconds + addSeconds
        rightTimerRunning = true
    }
    
    func applicationWillResignActive() {
        if isRunning {
            store.setObject(true, forKey: "background")
            store.setObject(NSDate(), forKey: "backgroundTime")
            
            if leftTimerRunning {
                leftTimerRunning = false
                store.setObject(leftTimerSeconds, forKey: "leftTimerSeconds")
            }
            
            if rightTimerRunning {
                rightTimerRunning = false
                store.setObject(rightTimerRunning, forKey: "rightTimerSeconds")
            }
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func leftTimerToggle(sender: UITapGestureRecognizer) {
        leftTimerRunning = !leftTimerRunning
    }
    
    @IBAction func rightTimerToggle(sender: UITapGestureRecognizer) {
        rightTimerRunning = !rightTimerRunning
    }
    
    
    // MARK: Own Properties
    
    var startTime: NSDate? {
        didSet {
            store.setObject(startTime, forKey: "startTime")
            store.synchronize()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            lastTime.text = dateFormatter.stringFromDate(startTime!)
            
            let nextTimeDateObject = startTime!.dateByAddingTimeInterval(nextTimeDelay)
            nextTime.text = dateFormatter.stringFromDate(nextTimeDateObject)
        }
    }
    
    var isRunning = false {
        didSet {
            if isRunning {
                startTime = NSDate()
                lastLabel.text = "Running"
            } else {
                lastLabel.text = "Last"
            }
        }
    }
    
    
    
    // MARK : Stopwatch
    
    // left
    var leftTimerObject = NSTimer()
    var leftTimerSeconds = 0.0
    
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
    
    func updateLeftTimer() {
        leftTimerSeconds++
        leftTimer.text = secondsDisplay(leftTimerSeconds)
    }
    
    // right
    var rightTimerObject = NSTimer()
    var rightTimerSeconds = 0.0
    
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
    
    func updateRightTimer() {
        rightTimerSeconds++
        rightTimer.text = secondsDisplay(rightTimerSeconds)
    }
    
    // reset
    
    @IBAction func resetButton(sender: UIButton) {
        if isRunning {
            appendNewTimer ()
        }
        
        isRunning = false
        leftTimerRunning = false
        leftTimer.text = "00:00"
        leftTimerSeconds = 0.0
        rightTimerRunning = false
        rightTimer.text = "00:00"
        rightTimerSeconds = 0.0
    }
    
    
    // MARK: Helpers
    
    var leftIsTheLast: Bool = false {
        didSet {
            if leftIsTheLast {
                leftTableCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                rightTableCell.accessoryType = UITableViewCellAccessoryType.None
            } else {
                leftTableCell.accessoryType = UITableViewCellAccessoryType.None
                rightTableCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
    }
    
    func appendNewTimer () {
        let newTimer = Timer()
        newTimer.beginTime = startTime!
        newTimer.leftTimer = leftTimerSeconds
        newTimer.rightTimer = rightTimerSeconds
        newTimer.leftIsTheLast = leftIsTheLast
        
        realm.write {
            self.realm.add(newTimer)
        }
    }
    
    func secondsDisplay(seconds: Double) -> String {
        let minutes = UInt8(seconds / 60.0)
        let seconds = UInt8(seconds % 60.0)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        return "\(strMinutes):\(strSeconds)"
    }
    
    func updateNextTimerLabel () {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let nextTimeDateObject = startTime!.dateByAddingTimeInterval(nextTimeDelay)
        nextTime.text = dateFormatter.stringFromDate(nextTimeDateObject)
        
        store.setObject(nextTimeDelay, forKey: "nextTimeDelay")
        store.synchronize()
    }
    
    
    // MARK: Navigation
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? EditNextTableViewController {
            updateNextTimerLabel()
        }
    }
}
