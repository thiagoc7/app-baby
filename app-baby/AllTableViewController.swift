//
//  AllTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/5/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit
import RealmSwift

class AllTableViewController: UITableViewController {
    
    let completedTimers = Realm().objects(Timer).sorted("beginTime", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTimers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
        self.tableView.dequeueReusableCellWithIdentifier(
            "timerCell", forIndexPath: indexPath)
            as! AllTableViewCell
        
        let timer = completedTimers[indexPath.row]
        cell.sideLabel.text = timer.lastSide
        cell.date.text = dateDisplay(timer.beginTime)
        cell.left.text = secondsDisplay(timer.leftTimer)
        cell.right.text = secondsDisplay(timer.rightTimer)
        
        return cell
    }
    
    func secondsDisplay(seconds: Double) -> String {
        let minutes = UInt8(seconds / 60.0)
        let seconds = UInt8(seconds % 60.0)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        return "\(strMinutes):\(strSeconds)"
    }
    
    func dateDisplay (date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d/MM - HH:mm"
        return dateFormatter.stringFromDate(date)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let realm = Realm()
            realm.write {
                realm.delete(self.completedTimers[indexPath.row])
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
