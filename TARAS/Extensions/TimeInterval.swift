//
//  TimeInterval.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/08.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var toTimeString: String {
        
        let day = Int(self/86400)
        let hour = Int((self.truncatingRemainder(dividingBy: 86400))/3600)
        let minute = Int((self.truncatingRemainder(dividingBy: 3600))/60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        
        var string = ""
        if day > 0 {
            string += "\(day):"
        }
        if hour > 0 {
            string += "\(hour):"
        }
        string += "\(minute.fillZero(2)):\(seconds.fillZero(2))"
        
        return string
    }
}
