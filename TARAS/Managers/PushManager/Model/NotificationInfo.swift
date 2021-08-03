//
//  NotificationInfo.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/24.
//

import Foundation

struct NotificationInfo {
    
    var notificationType: NotificationType
    var swsIdx: Int
    var serviceIdx: Int?
    var serviceUnitIdx: Int?
    var stopIdx: Int?
    
    init?(_ info: [String: AnyHashable]) {
        guard let type = info["notification_type"] as? String,
            let swsIdx = info["sws_idx"] as? Int else {
                return nil
        }
        
        self.notificationType = NotificationType.init(rawValue: type) ?? .arrived
        self.swsIdx = swsIdx
        
        if let serviceIdx = info["service_idx"] as? Int {
            self.serviceIdx = serviceIdx
        }
        if let serviceUnitIdx = info["service_unit_idx"] as? Int {
            self.serviceUnitIdx = serviceUnitIdx
        }
        if let stopIdx = info["stop_idx"] as? Int {
            self.stopIdx = stopIdx
        }
    }
}
