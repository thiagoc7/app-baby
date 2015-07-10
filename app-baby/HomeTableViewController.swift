//
//  HomeTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/6/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

var completedTimers = [Timer]()

class HomeTableViewController: UITableViewController {
    
    // MARK: Outlets

    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var nextTime: UILabel!
    @IBOutlet weak var leftTimer: UILabel!
    @IBOutlet weak var rightTimer: UILabel!
    
    @IBAction func leftButton(sender: UIButton) {
    }
    
    
    @IBAction func rightButton(sender: UIButton) {
    }
    
    @IBAction func resetButton(sender: UIButton) {
    }
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func leftTimerToggle(sender: UITapGestureRecognizer) {
        leftTimerRunning = !leftTimerRunning
    }
    
    @IBAction func rightTimerToggle(sender: UITapGestureRecognizer) {
        rightTimerRunning = !rightTimerRunning
    }
    
    // MARK : Stopwatch
    
    // left
    var leftTimerObject = NSTimer()
    var leftTimerSeconds = 0.0
    
    var leftTimerRunning: Bool = false {
        didSet {
            if leftTimerRunning {
                leftTimerObject = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateLeftTimer"), userInfo: nil, repeats: true)
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
            } else {
                rightTimerObject.invalidate()
            }
        }
    }
    
    func updateRightTimer() {
        rightTimerSeconds++
        rightTimer.text = secondsDisplay(rightTimerSeconds)
    }
    
    
    // MARK: Helpers
    
    func secondsDisplay(seconds: Double) -> String {
        let minutes = UInt8(seconds / 60.0)
        let seconds = UInt8(seconds % 60.0)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        return "\(strMinutes):\(strSeconds)"
    }
}
