//
//  ServiceLog.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 서비스 로그 정보
struct ServiceLog {
    /// 발생 일시
    let date: Date
    /// 서비스 로그 유형
    let type: ServiceLogState
}

extension ServiceLog {
    
    init?(json: [String: Any], with serviceUnits: [ServiceUnit], creator: User, robot: Robot?) {
        guard let date = json["time"] as? String else { return nil }
        
        //*현재 날짜이면, 로그 기록 날짜가 ISO형식이 아닌 것.
        self.date = date.ISO8601Date ?? Date()
        
        if let typeString = json["type"] as? String {
            switch typeString {
            case "service_created":
                self.type = .created(creator: creator.displayName)
            case "robot_assigned":
                let robotName = robot?.name ?? "알 수 없는 로봇"
                self.type = .robotAssigned(robot: robotName)
                //tmp: 로봇 출발 로그는 처리하지 않음
//            case "robot_departed":
//                if let unitIndex = json["unit_index"] as? Int,
//                   let destination = serviceUnits.first(where: { $0.orderWithinService == unitIndex })?.stop.name {
//                    self.type = .robotDeparted(destination: destination)
//                } else {
//                    self.type = .robotDeparted(destination: "알 수 없는 위치")
//                }
            case "robot_arrived":
                if let unitIndex = json["unit_index"] as? Int,
                   let destination = serviceUnits.first(where: { $0.orderWithinService == unitIndex })?.stop.name {
                    self.type = .robotArrived(serviceUnitIdx: unitIndex, destination: destination)
                } else {
                    self.type = .robotArrived(serviceUnitIdx: 0, destination: "알 수 없는 위치")
                }
            case "job_done":
                if let unitIndex = json["unit_index"] as? Int,
                   let destination = serviceUnits.first(where: { $0.orderWithinService == unitIndex })?.stop.name {
                    self.type = .workCompleted(destination: destination)
                } else {
                    self.type = .workCompleted(destination: "알 수 없는 위치")
                }
            case "service_finished":
                self.type = .finished
            case "service_canceled":
                self.type = .canceled
            case "service_failed":
                if let descriptionString = json["description"] as? String {
                    switch descriptionString {
                    case "timeout":
                        self.type = .failed(.timeout)
                    case "emergency":
                        self.type = .failed(.emergency)
                    case "robot":
                        self.type = .failed(.robot)
                    case "server":
                        self.type = .failed(.server)
                    default:
                        self.type = .failed(.unknown)
                    }
                } else {
                    self.type = .failed(.unknown)
                }
            default:
                //새로 추가되거나 분류되지 않은 유형이면 코드로 표시
                self.type = .unclassified(typeString)
            }
        } else {
            //로그 유형이 없으면 무시
            return nil
        }
    }
}

extension ServiceLog: Hashable {
    
    static func ==(lhs: ServiceLog, rhs: ServiceLog) -> Bool {
        return (lhs.hashValue == rhs.hashValue)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.date)
        hasher.combine(self.type.message)
    }
}
