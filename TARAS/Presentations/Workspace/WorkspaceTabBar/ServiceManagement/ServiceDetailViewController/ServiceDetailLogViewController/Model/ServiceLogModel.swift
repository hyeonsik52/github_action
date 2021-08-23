//
//  ServiceLogModel.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

class ServiceLogModel {
    
    let serviceLogIdx: Int
    
    let type: ServiceLogType
    let updateAt: Date
    
    let service: ServiceModel
    let serviceUnit: ServiceUnitModel?
    let user: ServiceUser?
    
    init(
        serviceLogIdx: Int,
        type: ServiceLogType,
        updateAt: Date,
        service: ServiceModel,
        serviceUnitIdx: Int,
        user: ServiceUser?
    ) {
        self.serviceLogIdx = serviceLogIdx
        self.type = type
        self.updateAt = updateAt
        
        self.service = service
        self.serviceUnit = service.serviceUnitList.first(where: {$0.serviceUnitIdx == serviceUnitIdx})
        self.user = user
    }
    
    var description: String {
        let userName = self.user?.name ?? "알 수 없는 유저"
        switch self.type {
        case .serviceCreated:
            /// 서비스 생성
            return "\(userName)님이 서비스를 생성하였습니다."
        case .serviceResponseCompleted:
            /// 서비스 응답 완료
            return "수신자의 답변이 완료되었습니다."
        case .serviceRejected:
            /// 서비스 거절
            return "수신자의 거절로 서비스가 취소되었습니다."
        case .serviceCanceled:
            /// 서비스 요청 취소
            return "\(userName)님이 서비스를 취소하였습니다."
        case .retryService:
            /// 서비스 재요청
            return "\(userName)님이 서비스를 다시 요청하였습니다."
        case .robotAssignment:
            /// 로봇 배정 완료
            return "로봇이 배정되었습니다. 서비스가 시작되었습니다."
        case .arrivalStop:
            /// 작업 위치 도착
            let isStartingPoint = (service.serviceUnitList.first?.serviceUnitIdx == serviceUnit?.serviceUnitIdx)
            if isStartingPoint {
                return "로봇이 출발지에 도착하였습니다."
            }else{
                let stop = self.serviceUnit?.place.name ?? "알 수 없는 위치"
                return "로봇이 \(stop)에 도착하였습니다."
            }
        case .startingServiceUnit:
            /// 작업 시작
            return "\(userName)님이 작업을 시작하였습니다."
        case .serviceUnitCompleted:
            /// 작업 완료
            return "\(userName)님이 작업을 완료하였습니다."
        case .canceleServiceUnitCompletion:
            /// 작업 완료 철회
            return "\(userName)님이 작업 완료를 철회하였습니다."
        case .serviceCompleted:
            /// 서비스 완료
            return "서비스가 완료되었습니다."
        case .servicePaused:
            /// 서비스 일시정지
            return "관리자가 서비스를 일시정지하였습니다."
        case .serviceRestarted:
            /// 서비스 재시작
            return "관리자가 서비스를 다시 시작하였습니다."
        case .serviceQuittedForcibly:
            /// 서비스 중단
            return "관리자가 서비스를 중단하였습니다."
        case .robotError:
            /// 기기 오류 발생
            return "로봇에 오류가 발생하여 서비스가 종료되었습니다."
        case .__unknown(let value):
            return value
        }
    }
}

extension ServiceLogModel {
    
    private static let provider = ManagerProvider()
    
    convenience init?(_ serviceLog: ServiceLogs.Log) {
        guard let service = serviceLog.service.asService else { return nil }
        
        let dateFormatter = ISO8601DateFormatter()
        let updateAt = dateFormatter.date(from: serviceLog.updateAt) ?? Date()
        
        let serviceModel = ServiceModel(service, with: Self.provider.serviceManager)
        let serviceUnitIdx = serviceLog.serviceUnit?.asServiceUnit?.serviceUnitIdx ?? -1
        let user = ServiceUser(.none, user: serviceLog.user?.asUser)
        
        self.init(
            serviceLogIdx: serviceLog.serviceLogIdx,
            type: serviceLog.type,
            updateAt: updateAt,
            service: serviceModel,
            serviceUnitIdx: serviceUnitIdx,
            user: user
        )
    }
}
