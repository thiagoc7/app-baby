//
//  Timer.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/7/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import Foundation

class Timer {
    
    var beginTime: String
    var leftTimer: String
    var rightTimer: String
    
    init( beginTime: String, leftTimer: String = "", rightTimer: String = "" ) {
        self.beginTime = beginTime
        self.leftTimer = leftTimer
        self.rightTimer = rightTimer
    }
    
}