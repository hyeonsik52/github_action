//
//  NotificationType.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/24.
//

import Foundation

enum NotificationType: String, Equatable {
    
    // 서비스 시작됨
    case serviceStarted = "service_started"
    
    // 작업 대기중
    case waitingWorkCompleted = "wating_work_to_completed"
    
    // 서비스 종료됨
    case serviceEnded = "service_ended"
    
    // 기타
    case `default`
}
