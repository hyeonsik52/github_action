//
//  ServiceState.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

/// 서비스 상태
enum ServiceState {
    /// 로봇 배정 중
    case robotAssigning
    /// 이동 대기 중
    case waiting
    /// 이동 중
    case moving
    /// 정차지 도착 (작업 대기)
    case arrived
    /// 서비스 완료
    case finished
    /// 서비스 중단
    case canceled
    /// 서비스 취소
    case failed
    /// 복귀 중
    case returning
    /// 알 수 없는 상태
    case unknown
    
    init(state: String) {
        switch state {
        case "Initialized",
            "waiting_for_robot_to_be_assigned_to_mission":
            self = .robotAssigning
        case "waiting_for_robot_to_depart":
            self = .waiting
        case "waiting_for_robot_to_arrive":
            self = .moving
        case "waiting_for_work_to_complete",
            "waiting_for_verification_code",
            "waiting_for_opening_parcel_lift",
            "waiting_for_closing_parcel_lift":
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
    
    var rawValues: [String] {
        switch self {
        case .robotAssigning:
            return [
                "Initialized",
                "waiting_for_robot_to_be_assigned_to_mission"
            ]
        case .waiting:
            return ["waiting_for_robot_to_depart"]
        case .moving:
            return ["waiting_for_robot_to_arrive"]
        case .arrived:
            return [
                "waiting_for_work_to_complete",
                "waiting_for_verification_code",
                "waiting_for_opening_parcel_lift",
                "waiting_for_closing_parcel_lift"
            ]
        case .finished:
            return ["Finished"]
        case .canceled:
            return ["Canceled"]
        case .failed:
            return ["Failed"]
        case .returning:
            return ["Returning"]
        default:
            return []
        }
    }
}
