//
//  NotificationInfo.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/24.
//

import Foundation

struct NotificationInfo {
    
    var notificationType: NotificationType = .received
    var workspaceId: String?
    var serviceId: String?
    
    init(_ info: [String: Any]) {
        self.workspaceId = info["workspaceId"] as? String
        self.serviceId = info["serviceId"] as? String
    }
}
