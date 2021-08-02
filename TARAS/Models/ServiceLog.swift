//
//  ServiceLog.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

//import Foundation
//
///// 서비스 로그 유형
//enum ServiceLogState {
//    /// 서비스 생성
//    case created
//    /// 로봇 배정
//    case robotAssigned
//    /// 목적지 도착
//    case arrived
//    /// 작업 완료
//    case workComplete
//    /// 서비스 완료
//    case complete
//    /// 서비스 중단
//    case canceled
//    /// 오류 발생
//    case error(ServiceLogError)
//}
//
//extension ServiceLogState {
//    
//    init?(raw: ServiceLogFragment) {
//        if let error = raw.errorStatus {
//            self = .error(.init(raw: error))
//        }else{
//            switch raw.type {
//            case .serviceCreated:
//                self = .created
//            case .robotAssignment:
//                self = .robotAssigned
//            case .arrivalStop:
//                self = .arrived
//            case .serviceUnitCompleted:
//                self = .workComplete
//            case .serviceCompleted:
//                self = .complete
//            case .serviceQuittedForcibly:
//                self = .canceled
//            default:
//                return nil
//            }
//        }
//    }
//}
//
///// 서비스 로그 정보
//struct ServiceLog {
//    /// 서비스 로그 인덱스
//    let idx: Int
//    /// 서비스 로그 유형
//    let type: ServiceLogState
//    /// 발생 일시
//    let date: Date
//    /// 로그 내용
//    let content: NSAttributedString
//}
