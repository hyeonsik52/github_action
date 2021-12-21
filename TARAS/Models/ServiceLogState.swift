//
//  ServiceLogState.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

/// 서비스 로그 유형
enum ServiceLogState {
    /// 서비스 요청
    case created(creator: String)
    /// 로봇 배정됨
    case robotAssigned
    /// 로봇 출발
    case robotDeparted(destination: String)
    /// 정차지에 로봇 도착
    case robotArrived(serviceUnitIdx: Int, destination: String)
    /// 서비스 완료
    case finished
    /// 서비스 중단
    case canceled(manager: String)
    /// 서비스 실패
    case failed(ServiceLogStateFailType)
    /// 분류되지 않은 유형
    case unclassified(String)
    
    var message: String {
        switch self {
        case .created(let creator):
            return "\(creator)님이 서비스를 요청하였습니다."
        case .robotAssigned:
            return "로봇이 배정되었습니다."
        case .robotDeparted(let destination):
            return "로봇이 \(destination)(으)로 출발하였습니다."
        case .robotArrived(_, let destination):
            return "로봇이 \(destination)에 도착하였습니다."
        case .finished:
            return "로봇 배달 서비스가 완료되었습니다."
        case .canceled(let manager):
            return "\(manager)님이 서비스를 중단하였습니다."
        case .failed(let reason):
            return reason.message
        case .unclassified(let typeString):
            return typeString
        }
    }
}

enum ServiceLogStateFailType: String {
    /// 타임아웃
    case timeout
    /// 비상정지
    case emergency
    /// 로봇오류
    case robot
    /// 서버오류
    case server
    /// 알수없음
    case unknown
    
    var message: String {
        switch self {
        case .timeout:
            return "대기시간 초과로 서비스가 종료되었습니다."
        case .emergency:
            return "비상정지로 인해 서비스가 종료되었습니다."
        case .robot:
            return "로봇 오류가 발생하여 서비스가 종료되었습니다."
        case .server:
            return "서버 오류가 발생하여 서비스가 종료되었습니다."
        case .unknown:
            return "알 수 없는 오류가 발생하여 서비스가 종료되었습니다."
        }
    }
}
