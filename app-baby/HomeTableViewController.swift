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

    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var lastTimeLeft: UILabel!
    @IBOutlet weak var lastTimeRight: UILabel!
    @IBOutlet weak var nextTime: UILabel!
    @IBOutlet weak var nextTimeText: UILabel!
    @IBOutlet weak var leftTimer: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightTimer: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftTableCell: UITableViewCell!
    @IBOutlet weak var rightTableCell: UITableViewCell!
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var leftPlay: UIImageView!
    @IBOutlet weak var rightPlay: UIImageView!
    
    // MARK: Init
    
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        setLastTimer()
    }
    
    
    // MARK: Background
    
    let store = NSUserDefaults.standardUserDefaults()
    
    func applicationDidBecomeActive() {
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
    
    func resumeLeftTimer(seconds: Double, backgroundTime: NSDate) {
        leftTimerSeconds = seconds + NSDate().timeIntervalSinceDate(backgroundTime)
        leftTimerRunning = true
    }
    
    func resumeRightTimer(seconds: Double, backgroundTime: NSDate) {
        rightTimerSeconds = seconds + NSDate().timeIntervalSinceDate(backgroundTime)
        rightTimerRunning = true
    }
    
    func applicationWillResignActive() {
        if isRunning {
            store.setObject(true, forKey: "background")
            store.setObject(NSDate(), forKey: "backgroundTime")
            store.setObject(startTime, forKey: "startTime")
            
            if leftTimerRunning {
                leftTimerRunning = false
                store.setObject(leftTimerSeconds, forKey: "leftTimerSeconds")
            }
            
            if rightTimerRunning {
                rightTimerRunning = false
                store.setObject(rightTimerSeconds, forKey: "rightTimerSeconds")
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
            startLabel.text = dateFormatter.stringFromDate(startTime!)
        }
    }
    
    var isRunning = false {
        didSet {
            if isRunning {
                startTime = NSDate()
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
                leftPlay.highlighted = true
                if !isRunning {
                    isRunning = true
                }
            } else {
                leftTimerObject.invalidate()
                leftPlay.highlighted = false
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
                rightPlay.highlighted = true
                if !isRunning {
                    isRunning = true
                }
            } else {
                rightTimerObject.invalidate()
                rightPlay.highlighted = false
            }
        }
    }
    
    func updateRightTimer() {
        rightTimerSeconds++
        rightTimer.text = secondsDisplay(rightTimerSeconds)
    }
    
    // reset
    
    @IBAction func reset(sender: UITapGestureRecognizer) {
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
        startLabel.text = "-- --"
        setLastTimer()

    }
    
    
    // MARK: Helpers
    
    var leftIsTheLast: Bool = false {
        didSet {
            if leftIsTheLast {
                rightIcon.highlighted = false
                leftIcon.highlighted = true
            } else {
                leftIcon.highlighted = false
                rightIcon.highlighted = true
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
    
    var updateNextTimerObject = NSTimer()
    func updateNextTimerText() {
        let helperText 
    }
    
    func setLastTimer() {
        
        if store.objectForKey("nextTimeDelay") != nil {
            nextTimeDelay = store.objectForKey("nextTimeDelay") as! Double
        }
        
        let lastTimerObject = realm.objects(Timer).last
        if lastTimerObject != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            lastTime.text = dateFormatter.stringFromDate(lastTimerObject!.beginTime)
            
            let nextTimeDateObject = lastTimerObject!.beginTime.dateByAddingTimeInterval(nextTimeDelay)
            nextTime.text = dateFormatter.stringFromDate(nextTimeDateObject)
            
            lastTimeLeft.text = secondsDisplay(lastTimerObject!.leftTimer)
            lastTimeRight.text = secondsDisplay(lastTimerObject!.rightTimer)
            
            if lastTimerObject!.leftIsTheLast {
                leftImage.highlighted = true
                rightImage.highlighted = false
            } else {
                leftImage.highlighted = false
                rightImage.highlighted = true
            }
        }
    }
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    
    // MARK: Swipe Actions
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let less1 = UITableViewRowAction(style: .Normal, title: "-1m") { action, index in
            if indexPath.row == 0 {
                
                if self.leftTimerSeconds < 61 {
                    self.leftTimerSeconds = 0
                } else {
                    self.leftTimerSeconds -= 60
                }
                
            } else if indexPath.row == 1 {
                
                if self.rightTimerSeconds < 61 {
                    self.rightTimerSeconds = 0
                } else {
                    self.rightTimerSeconds -= 60
                }
                
            }
        }
        
        
        let more1 = UITableViewRowAction(style: .Normal, title: "+1m") { action, index in
            if indexPath.row == 0 {
                self.leftTimerSeconds += 60
            } else if indexPath.row == 1 {
                self.rightTimerSeconds += 60
            }
        }
        
        let startLess5 = UITableViewRowAction(style: .Normal, title: "-5m") { action, index in
            self.startTime = self.startTime!.dateByAddingTimeInterval(-300)
        }
        
        let startMore5 = UITableViewRowAction(style: .Normal, title: "+5m") { action, index in
            self.startTime = self.startTime!.dateByAddingTimeInterval(300)
        }

        
        less1.backgroundColor = UIColorFromRGB("FC3158")
        more1.backgroundColor = UIColor.lightGrayColor()
        startLess5.backgroundColor = UIColorFromRGB("FC3158")
        startMore5.backgroundColor = UIColor.lightGrayColor()
        
        if indexPath.section == 1 {
            return [more1, less1]
        } else {
            return [startMore5, startLess5]
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        if isRunning && (indexPath.section == 1 || indexPath.section == 2) {
            return true
        } else {
            return false
        }
    }
    
    override  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
}
