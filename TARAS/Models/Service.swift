//
//  Service.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 서비스 상태
enum ServiceState {
    /// 로봇 배정 중
    case robotAssigning
    /// 출발 준비 중
    case waiting
    /// 이동 중
    case moving
    /// 정차지 도착
    case arrived
    /// 서비스 완료
    case completed
    /// 서비스 취소
    case canceled
    
    /// 알 수 없는 상태
    case unknowned
}

extension ServiceState {
    
    init(status: String, step: Int) {
        switch status {
        case "Canceled", "Failed":
            self = .canceled
        case "Finished":
            self = .completed
        case "waiting_for_robot_to_depart":
            self = .waiting
        case "waiting_for_robot_to_arrive":
            self = .moving
        case "waiting_for_work_to_complete":
            self = .arrived
        case "status_is_not_provided":
            self = .unknowned
        default:
            if step == 0 {
                self = .robotAssigning
            } else {
                self = .unknowned
            }
        }
    }
}
/// 서비스 정보
struct Service {
    /// 서비스 아이디
    let id: Int
    /// 서비스 상태
    let status: ServiceState
    /// 서비스 번호
    let serviceNumber: String
    /// 생성일자
    let createdAt: Date
    /// 종료일자
    let finishedAt: Date
    /// 배정 로봇
    let robot: Robot?
    /// 생성자
    let creator: User
    /// 단위서비스 목록
    let serviceUnits: [ServiceUnit]
    /// 현재 진행 중 작업(단위서비스) 인덱스
    let currentServiceUnitIdx: Int
}

extension Service {
    
    var isArrivedToMe: Bool {
        let isArrived = (self.status == .arrived)
        let currentServiceUnit = self.serviceUnits[self.currentServiceUnitIdx]
        let isContainedMe = currentServiceUnit.receivers.contains { $0.id == "내 유저 아이디" }
        return (isArrived && isContainedMe)
    }
        
    var statusDescription: String {
        switch self.status {
        case .robotAssigning:
            return "로봇 배정 중"
        case .waiting:
            return "출발 준비 중"
        case .moving:
            return "이동 중"
        case .arrived:
            return "정차지 도착"
        case .completed:
            return "서비스 완료"
        case .canceled:
            return "서비스 취소"
        default:
            return "알 수 없는 상태"
        }
    }
}
