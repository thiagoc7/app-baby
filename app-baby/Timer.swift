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
    dynamic var beginTime = NSDate()
    dynamic var leftTimer: Double = 0.0
    dynamic var rightTimer: Double = 0.0
    dynamic var leftIsTheLast = true
    
    var lastSide: String {
        if self.leftIsTheLast {
            return "L"
        } else {
            return "R"
        }
    }
}