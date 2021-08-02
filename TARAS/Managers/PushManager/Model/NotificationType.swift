//
//  NotificationType.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/24.
//

import Foundation

enum NotificationType: String, Equatable {
    
    // 로봇 배정됨 (서비스 생성)
    case created = "robot_assignment"
    
    // 목적지에 도착
    case arrived = "robot_on_stop"
}
