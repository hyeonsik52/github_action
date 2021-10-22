//
//  NotificationInfo.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/24.
//

import Foundation

struct NotificationInfo {
    
    var notificationType: NotificationType
    var workspaceId: String
    var serviceId: String?
    var serviceUnitId: String?
    var stopId: String?
    
    init?(_ info: [String: AnyHashable]) {
        guard let type = info["notification_type"] as? String,
              let workspaceId = info["workspace_id"] as? String else { return nil }
        
        self.notificationType = NotificationType.init(rawValue: type) ?? .default
        self.workspaceId = workspaceId
        
        if let serviceId = info["service_id"] as? String {
            self.serviceId = serviceId
        }
        if let serviceUnitId = info["service_unit_id"] as? String {
            self.serviceUnitId = serviceUnitId
        }
        if let stopId = info["stop_id"] as? String {
            self.stopId = stopId
        }
    }
}
