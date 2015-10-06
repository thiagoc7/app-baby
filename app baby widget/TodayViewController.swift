//
//  TodayViewController.swift
//  app baby widget
//
//  Created by Thiago Boucas Correa on 7/18/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeDelayLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    let store = NSUserDefaults(suiteName: "group.app.baby")!
    
    var nextTimeIn: Double {
        store.synchronize()
        if let storedNextTimerIn = store.objectForKey("nextTimerIn") as? Double {
            return storedNextTimerIn
        } else {
            return 10800.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextLabel.text = NSLocalizedString("NEXT", comment: "next")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setLabels()
    }
    
    @IBAction func backgroundTap(sender: UITapGestureRecognizer) {
        let url: NSURL = NSURL(fileURLWithPath: "app-baby://")
        self.extensionContext?.openURL(url, completionHandler: nil)
    }
    
    func setLabels() {
        store.synchronize()
        
        if let next = store.objectForKey("startTime") as? NSDate {
            let delayedDate = next.dateByAddingTimeInterval(nextTimeIn)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
            print(dateFormatter.stringFromDate(delayedDate), terminator: "")
            timeLabel.text = dateFormatter.stringFromDate(delayedDate)
            
            setDelayLabel(delayedDate.timeIntervalSinceDate(NSDate()))
        }
    }
    
    func setDelayLabel(interval: Double) {
        if interval > 0.0 {
            let roundedInterval = round(interval / 60) * 60
            let formatter = NSDateComponentsFormatter()
            formatter.unitsStyle = .Short
            timeDelayLabel.text = NSLocalizedString("IN", comment: "in") + formatter.stringFromTimeInterval(roundedInterval)!
        } else {
            timeDelayLabel.text = NSLocalizedString("OVERDUE", comment: "overdue")
        }
    }
}
