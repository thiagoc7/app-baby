//
//  AllTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/5/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class AllTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleTimers()
    }
    
    func loadSampleTimers() {
        let timer1 = Timer(beginTime: "Timer 1")
        let timer2 = Timer(beginTime: "Timer 3")
        let timer3 = Timer(beginTime: "Timer 3")
        
        completedTimers += [timer1, timer1, timer3]
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
        
        cell.timerLabel.text = timer.beginTime
        return cell
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
            completedTimers.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation
    
    
    @IBAction func unwindToTimersList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? NewTimerTableViewController, timer = sourceViewController.timer {
            // Add a new timer.
            let newIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            completedTimers.insert(timer, atIndex: 0)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Top)
        }
    }

}
