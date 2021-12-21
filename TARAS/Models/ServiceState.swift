//
//  ServiceState.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

/// 서비스 상태
enum ServiceState: String {
    /// 로봇 배정 중
    case robotAssigning = "Initialization"
    /// 이동 대기 중
    case waiting = "waiting_for_robot_to_depart"
    /// 이동 중
    case moving = "waiting_for_robot_to_arrive"
    /// 정차지 도착 (작업 대기)
    case arrived = "waiting_for_work_to_complete"
    /// 서비스 완료
    case finished = "Finished"
    /// 서비스 중단
    case canceled = "Canceled"
    /// 서비스 취소
    case failed = "Failed"
    /// 복귀 중
    case returning = "Returning"
    /// 알 수 없는 상태
    case unknown = ""
    
    init(state: String) {
        switch state {
        case "Initialization":
            self = .robotAssigning
        case "waiting_for_robot_to_depart":
            self = .waiting
        case "waiting_for_robot_to_arrive":
            self = .moving
        case "waiting_for_work_to_complete":
            self = .arrived
        case "Finished":
            self = .finished
        case "Canceled":
            self = .canceled
        case "Failed":
            self = .failed
        case "Returning":
            self = .returning
        default:
            self = .unknown
        }
    }
}
