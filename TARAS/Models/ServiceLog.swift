//
//  ServiceLog.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 서비스 로그 유형
enum ServiceLogState {
    /// 서비스 생성됨
    case created
    /// 로봇 배정됨
    case robotAssigned
    /// 정차지 도착
    case arrived
    /// 작업 완료
    case workComplete
    /// 서비스 완료
    case complete
    /// 서비스 취소
    case canceled(ServiceLogError)
}

extension ServiceLogState {
    
    init?(raw: String) {
        switch raw {
        case "service_started":
            self = .created
        case "robot_assigned":
            self = .robotAssigned
        case "robot_arrived":
            self = .robotAssigned
        case "job_done":
            self = .workComplete
        case "service_canceled":
            self = .canceled(.unknown)
        default:
            return nil
        }
    }
}

/// 서비스 로그 정보
struct ServiceLog {
    /// 발생 일시
    let date: Date
    /// 서비스 로그 유형
    let type: ServiceLogState
}

extension ServiceLog {
    
    init(json: [String: Any]) {
        
        if let time = json["time"] as? String,
           let date = ISO8601DateFormatter().date(from: time) {
            self.date = date
        } else {
            self.date = Date()
        }
        
        if let typeString = json["type"] as? String,
           let type = ServiceLogState(raw: typeString) {
            self.type = type
        } else {
            self.type = .created
        }
    }
}
