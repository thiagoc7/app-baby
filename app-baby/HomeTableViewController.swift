//
//  HomeTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/6/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit
import RealmSwift

class HomeTableViewController: UITableViewController, TimerManagerDelagate {
    
    // MARK: Outlets
    
    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var lastTimeLeft: UILabel!
    @IBOutlet weak var lastTimeRight: UILabel!
    @IBOutlet weak var nextTime: UILabel!
    @IBOutlet weak var nextTimeDelayLabel: UILabel!
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
    
    let timerManager = TimerManager()
    var settings = SettingsManager()
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerManager.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(timerManager, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(timerManager, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        setLastTimer()
        
        settings = SettingsManager()
        nextTimeDelayLabel.text = "In " + settings.nextTimerInString
    }
    
    // MARK: IBActions
    
    @IBAction func leftTimerToggle(sender: UITapGestureRecognizer) {
        timerManager.leftTimerRunning = !timerManager.leftTimerRunning
        leftPlay.highlighted = timerManager.leftTimerRunning
    }
    
    @IBAction func rightTimerToggle(sender: UITapGestureRecognizer) {
        timerManager.rightTimerRunning = !timerManager.rightTimerRunning
        rightPlay.highlighted = timerManager.rightTimerRunning
    }
    
    @IBAction func reset(sender: UITapGestureRecognizer) {
        timerManager.saveCurrentTimer()
        setLastTimer()
    }
    
    //MARK: TimerMaganer Delegate Methods
    
    func updateLeftTimerLabel(text: String) {
        leftTimer.text = text
    }
    
    func updateRightTimerLabel(text: String) {
        rightTimer.text = text
    }
    
    func updateStartTimerLabel(text: String) {
        startLabel.text = text
    }
    
    func updateLeftAndRightIcon(update: Bool) {
        leftIcon.highlighted = update
        rightIcon.highlighted = !update
    }
    
    // MARK: Helpers
    
    func setLastTimer() {
        if let lastTimerObject = timerManager.realm.objects(Timer).last {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            lastTime.text = dateFormatter.stringFromDate(lastTimerObject.startTime)
            nextTime.text = dateFormatter.stringFromDate(lastTimerObject.startTime.dateByAddingTimeInterval(settings.nextTimerIn))
            lastTimeLeft.text = lastTimerObject.leftTimerSecondsString
            lastTimeRight.text = lastTimerObject.rightTimerSecondsString
            leftImage.highlighted = lastTimerObject.leftIsTheLast
            rightImage.highlighted = !lastTimerObject.leftIsTheLast
            leftTimer.text = "00:00"
            rightTimer.text = "00:00"
            leftPlay.highlighted = timerManager.leftTimerRunning
            rightPlay.highlighted = timerManager.rightTimerRunning
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
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let less1 = UITableViewRowAction(style: .Normal, title: "-1m") { action, index in
            if indexPath.row == 0 {
                
                if self.timerManager.timer.leftTimerSeconds < 61 {
                    self.timerManager.timer.leftTimerSeconds = 0
                } else {
                    self.timerManager.timer.leftTimerSeconds -= 60
                }
                
            } else if indexPath.row == 1 {
                
                if self.timerManager.timer.rightTimerSeconds < 61 {
                    self.timerManager.timer.rightTimerSeconds = 0
                } else {
                    self.timerManager.timer.rightTimerSeconds -= 60
                }
                
            }
        }
        
        let more1 = UITableViewRowAction(style: .Normal, title: "+1m") { action, index in
            if indexPath.row == 0 {
                self.timerManager.timer.leftTimerSeconds += 60
            } else if indexPath.row == 1 {
                self.timerManager.timer.rightTimerSeconds += 60
            }
        }
        
        let startLess5 = UITableViewRowAction(style: .Normal, title: "-5m") { action, index in
            self.timerManager.timer.startTime = self.timerManager.timer.startTime.dateByAddingTimeInterval(-300)
        }
        
        let startMore5 = UITableViewRowAction(style: .Normal, title: "+5m") { action, index in
            self.timerManager.timer.startTime = self.timerManager.timer.startTime.dateByAddingTimeInterval(300)
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
        if timerManager.isRunning && (indexPath.section == 1 || indexPath.section == 2) {
            return true
        } else {
            return false
        }
    }
    
    override  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
}
