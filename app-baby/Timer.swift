//
//  Timer.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/7/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import RealmSwift

// Dog model
class Timer: Object {
    dynamic var startTime = NSDate()
    dynamic var leftTimerSeconds: Double = 0.0
    dynamic var rightTimerSeconds: Double = 0.0
    dynamic var leftIsTheLast = true
    
    var leftTimerSecondsString: String {
        return secondsString(leftTimerSeconds)
    }
    
    var rightTimerSecondsString: String {
        return secondsString(rightTimerSeconds)
    }
    
    var startTimeDateString: String {
        return dateString(startTime)
    }
    
    var startTimeHourString: String {
        return hourString(startTime)
    }
    
    func secondsString (seconds: Double) -> String {
        let minutes = UInt8(seconds / 60.0)
        let seconds = UInt8(seconds % 60.0)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        return "\(strMinutes):\(strSeconds)"
    }
    
    func hourString (date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    func dateString (date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d/M"
        return dateFormatter.stringFromDate(date)
    }
}