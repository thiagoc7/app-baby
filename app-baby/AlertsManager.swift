//
//  AlertsManager.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/16/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class AlertsManager: NSObject {
    
    // MARK: Computed Properties
    let settings = SettingsManager()
    let sound = UILocalNotificationDefaultSoundName
    
    let leftReminderId = "LEFT_REMINDER"
    let rightReminderId = "RIGHT_REMINDER"
    let totalReminderId = "TOTAL_REMINDER"
    let nextReminderId = "NEXT_REMINDER"
    
    var leftReminderBodyText: String {
        return NSLocalizedString("LEFT_SIDE", comment: "left side") + " - " + settings.eachBreastReminderString
    }
    
    var rightReminderBodyText: String {
        return "right side - " + settings.eachBreastReminderString
    }
    
    var totalReminderBodyText: String {
        return "total - " + settings.totalTimeReminderString
    }
    
    var nextReminderBodyText: String {
        return "It's time! - " + settings.nextTimerInString + " from last feeding"
    }
    
    
    // MARK: Methods
    
    func setLeftTimerReminder(seconds: Double, isRunning: Bool) {
        deleteLeftTimerReminder()
        if settings.eachBreastReminder > seconds && isRunning {
            let remainingSeconds = settings.eachBreastReminder - seconds
            createNotification(NSDate(timeIntervalSinceNow: remainingSeconds), body: leftReminderBodyText, identifier: leftReminderId)
        }
    }
    
    func setRightTimerReminder(seconds: Double, isRunning: Bool) {
        deleteRightTimerReminder()
        if settings.eachBreastReminder > seconds && isRunning {
            let remainingSeconds = settings.eachBreastReminder - seconds
            createNotification(NSDate(timeIntervalSinceNow: remainingSeconds), body: rightReminderBodyText, identifier: rightReminderId)
        }
    }
    
    func setTotalTimerReminder(date: NSDate) {
        deleteTotalTimerReminder()
        createNotification(date.dateByAddingTimeInterval(settings.totalTimeReminder), body: totalReminderBodyText, identifier: totalReminderId)
    }
    
    func setNextTimerReminder(date: NSDate) {
        deleteNextTimerReminder()
        if settings.nextTimerReminder {
            createNotification(date.dateByAddingTimeInterval(settings.nextTimerIn), body: nextReminderBodyText, identifier: nextReminderId)
        }
    }
    
    
    func deleteLeftTimerReminder() {
        deleteNotification(leftReminderId)
    }
    
    func deleteRightTimerReminder() {
        deleteNotification(rightReminderId)
    }
    
    func deleteTotalTimerReminder() {
        deleteNotification(totalReminderId)
    }
    
    func deleteNextTimerReminder() {
        deleteNotification(nextReminderId)
    }
    
    
    // MARK: Helpers
    
    func deleteNotification(identifier: String) {
        for notification in (UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification]) {
            if (notification.userInfo!["UUID"] as! String == identifier) {
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
    }
    
    func createNotification(time: NSDate, body: String, identifier: String) {
        let notification = UILocalNotification()
        
        notification.soundName = sound
        notification.userInfo = ["UUID": identifier]
        
        notification.fireDate = time
        notification.alertBody = body
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
