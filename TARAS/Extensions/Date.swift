//
//  Date.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/29.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension Date {
    
    //현재 시간을 기준으로 지난 시간에 따른 포맷 문자열 출력
    var overDescription: String {
        return self.overDescription(Date())
    }
    
    func overDescription(_ base: Date) -> String {
        
        let isToday = NSCalendar.current.isDateInToday(self)
        
        let dateFormatter = DateFormatter()
        
        //선호 언어는 무조건 1개 이상이므로 인덱스 접근할 수 있다
        let localId = Locale.preferredLanguages[0]
        dateFormatter.locale = Locale(identifier: localId)
        
        if isToday {

            let nowInterval = base.timeIntervalSince1970
            let interval = self.timeIntervalSince1970
            let gapInterval = max(0, nowInterval - interval)
            
            if gapInterval < 30*60 {
                let overMinute = Int(gapInterval/60)
                return "\(overMinute)분 전"
            }else{
                dateFormatter.dateFormat = "a hh:mm"
                return dateFormatter.string(from: self)
            }
        }else{
            dateFormatter.dateFormat = "yy.MM.dd a hh:mm"
            return dateFormatter.string(from: self)
        }
    }
    
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
