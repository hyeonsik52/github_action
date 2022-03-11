//
//  ServiceLogState.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

/// 서비스 로그 유형
enum ServiceLogState: Equatable {
    /// 서비스 요청
    case created(creator: String)
    /// 로봇 배정됨
    case robotAssigned(robot: String)
    //tmp: 로봇 출발 로그는 처리하지 않음
//    /// 로봇 출발
//    case robotDeparted(destination: String)
    /// 정차지에 로봇 도착
    case robotArrived(serviceUnitIdx: Int, destination: String)
    /// 작업 완료
    case workCompleted(destination: String)
    /// 서비스 완료
    case finished
    /// 서비스 중단
    case canceled
    /// 서비스 실패
    case failed(ServiceLogStateFailType)
    /// 분류되지 않은 유형
    case unclassified(String)
    
    var message: String {
        switch self {
        case .created(let creator):
            return "\(creator)님이 서비스를 요청하였습니다."
        case .robotAssigned(let robot):
            return "\(robot) 로봇이 배정되었습니다."
            //tmp: 로봇 출발 로그는 처리하지 않음
//        case .robotDeparted(let destination):
//            return "로봇이 \(destination)(으)로 출발하였습니다."
        case .robotArrived(_, let destination):
            return "로봇이 \(destination)에 도착하였습니다."
        case .workCompleted(let destination):
            return "\(destination)에서의 작업이 완료되었습니다."
        case .finished:
            return "서비스가 완료되었습니다."
        case .canceled:
            return "관리자가 서비스를 취소하였습니다."
        case .failed(let reason):
            return reason.message
        case .unclassified(let typeString):
            return typeString
        }
    }
    
    var styledMessage: NSAttributedString {
        let nomalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.purple4A3C9F]
        switch self {
        case .created(let creator):
            let attributedString = NSMutableAttributedString(string: creator, attributes: nomalAttributes)
            attributedString.append(.init(string: "님이 서비스를 요청하였습니다."))
            return attributedString
        case .robotAssigned(let robot):
            let attributedString = NSMutableAttributedString(string: robot, attributes: nomalAttributes)
            attributedString.append(.init(string: " 로봇이 배정되었습니다."))
            return attributedString
            //tmp: 로봇 출발 로그는 처리하지 않음
//        case .robotDeparted(let destination):
//            let attributedString = NSMutableAttributedString(string: "로봇이 ")
//            attributedString.append(.init(string: destination, attributes: nomalAttributes))
//            attributedString.append(.init(string: "(으)로 출발하였습니다."))
//            return attributedString
        case .robotArrived(_, let destination):
            let attributedString = NSMutableAttributedString(string: "로봇이 ")
            attributedString.append(.init(string: destination, attributes: nomalAttributes))
            attributedString.append(.init(string: "에 도착하였습니다."))
            return attributedString
        case .workCompleted(let destination):
            let attributedString = NSMutableAttributedString(string: destination, attributes: nomalAttributes)
            attributedString.append(.init(string: "에서의 작업이 완료되었습니다."))
            return attributedString
        case .finished:
            return .init(string: "서비스가 완료되었습니다.")
        case .canceled:
            let attributedString = NSMutableAttributedString(
                string: "관리자가 서비스를 취소",
                attributes: [.foregroundColor: UIColor.redEC5C4A]
            )
            attributedString.append(.init(string: "하였습니다."))
            return attributedString
        case .failed(let reason):
            return reason.styledMessage
        case .unclassified(let typeString):
            return .init(string: typeString)
        }
    }
    
    static func == (lhs: ServiceLogState, rhs: ServiceLogState) -> Bool {
        switch (lhs, rhs) {
        case (.created(let left), .created(let right)):
            return left == right
        case (.robotAssigned(let left), .robotAssigned(let right)):
            return left == right
        case (.robotArrived(let left1, let left2), .robotArrived(let right1, let right2)):
            return left1 == right1 && left2 == right2
        case (.workCompleted(let left), .workCompleted(let right)):
            return left == right
        case (.finished, .finished):
            return true
        case (.canceled, .canceled):
            return true
        case (.failed(let left), .failed(let right)):
            return left == right
        case (.unclassified(let left), .unclassified(let right)):
            return left == right
        default:
            return false
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
        let frontString: String = {
            switch self {
            case .timeout: return "대기시간 초과"
            case .emergency: return "비상정지"
            case .robot: return "기기 오류"
            case .server: return "서버 오류"
            case .unknown: return "알 수 없는 오류"
            }
        }()
        return "\(frontString)로 서비스가 종료되었습니다."
    }
    
    var styledMessage: NSAttributedString {
        let frontString: String = {
            switch self {
            case .timeout: return "대기시간 초과"
            case .emergency: return "비상정지"
            case .robot: return "기기 오류"
            case .server: return "서버 오류"
            case .unknown: return "알 수 없는 오류"
            }
        }()
        let attributedString = NSMutableAttributedString(
            string: frontString,
            attributes: [.foregroundColor: UIColor.redEC5C4A]
        )
        attributedString.append(.init(string: "로 서비스가 종료되었습니다."))
        return attributedString
    }
}
