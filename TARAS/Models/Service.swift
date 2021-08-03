//
//  Service.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

//import Foundation
//
///// 서비스 상태
//enum ServiceState {
//    /// 로봇 배정 중
//    case robotAssigning
//    /// 이동 대기 중
//    case waiting
//    /// 이동 중
//    case moving
//    /// 로봇 도착
//    case arrived
//    /// 서비스 완료
//    case completed
//    /// 비정상 종료
//    case terminated
//}
//
//extension ServiceState {
//    
//    init(raw: ServiceStatus) {
//        switch raw {
//        case .waitingResponse,
//             .waitingRobotAssignment:
//            self = .robotAssigning
//        case .waitingToMove:
//            self = .waiting
//        case .moving:
//            self = .moving
//        case .stop,
//             .working:
//            self = .arrived
//        case .completed:
//            self = .completed
//        default:
//            self = .terminated
//        }
//    }
//}
//
///// 서비스 템플릿 정보
//struct ServiceTemplate {
//    /// 서비스 유형 인덱스
//    let idx: Int
//    /// 서비스 유형 코드
//    let code: String
//    /// 서비스 유형 이름
//    let name: String
//}
//
///// 서비스 정보
//struct Service {
//    /// 서비스 인덱스
//    let idx: Int
//    /// 서비스 유형 정보
//    let template: ServiceTemplate
//    /// 서비스 상태
//    let status: ServiceState
//    /// 서비스 번호
//    let serviceId: String
//    /// 생성일자
//    let createAt: Date
//    /// 배정 로봇
//    let robot: Robot?
//    /// 단위서비스 목록
//    let serviceUnits: [ServiceUnit]
//    /// 서비스 진행 현황
//    let progressDescription: NSAttributedString?
//}
//
//extension Service {
//    
//    var isArrivedToMe: Bool {
//        guard let myServiceUnit = self.serviceUnits.first(where: { $0.worker.isMe })
//        else{
//            return false
//        }
//        return (myServiceUnit.status == .stop || myServiceUnit.status == .working)
//    }
//    
//    var statusDescription: String {
//        switch self.status {
//        case .robotAssigning:
//            return "배달 준비 중"
//        case .completed:
//            return "배달 완료"
//        case .terminated:
//            return "배달 중단"
//        case .arrived:
//            if isArrivedToMe {
//                return "내 위치 도착"
//            }
//        default: break
//        }
//        return "배달 중"
//    }
//    
//    var isDelivering: Bool {
//        switch self.status {
//        case .robotAssigning,
//             .completed,
//             .terminated:
//            return false
//        case .arrived:
//            if isArrivedToMe {
//                return false
//            }
//        default: break
//        }
//        return true
//    }
//    
//    var processingServicUnit: ServiceUnit? {
//        guard let processing = self.serviceUnits.last(where: { $0.status == .moving || $0.status == .stop }) else {
//            return self.serviceUnits.first
//        }
//        return processing
//    }
//}
