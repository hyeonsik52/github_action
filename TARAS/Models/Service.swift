//
//  Service.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 서비스 정보
struct Service: Identifiable {
    /// 서비스 아이디
    let id: String
    /// 서비스 유형
    let type: ServiceType
    /// 서비스 상태
    let status: ServiceState
    /// 서비스 단계
    let phase: ServicePhase
    /// 서비스 번호
    let serviceNumber: String
    /// 요청일자
    let requestedAt: Date
    /// 시작일자
    let startedAt: Date?
    /// 종료일자
    let finishedAt: Date?
    /// 배정 로봇
    let robot: Robot?
    /// 생성자
    let creator: User
    /// 단위서비스 목록
    let serviceUnits: [ServiceUnit]
    /// 현재 진행 중 작업(단위서비스) 인덱스
    let currentServiceUnitIdx: Int
    /// 이동 거리 (m)
    let travelDistance: Double?
    /// 진행 기록 셋
    let serviceLogSet: ServiceLogSet
}

extension Service: FragmentModel {

    init(_ fragment: ServiceFragment) {
        
        self.id = fragment.id
        
        if let type = fragment.type {
            self.type = .init(rawValue: type) ?? .general
        } else {
            self.type = .unknown
        }
        
        if let state = fragment.state {
            self.status = .init(state: state)
        } else {
            self.status = .unknown
        }
        
        self.serviceNumber = fragment.serviceNumber ?? "-"
        
        let creatorInfo = fragment.creator?.toDictionary
        let username = (creatorInfo?["id"] as? String) ?? User.unknownName
        let creatorName = (creatorInfo?["name"] as? String) ?? "알 수 없는 유저"
        self.creator = .init(
            id: User.unknownId,
            username: username,
            displayName: creatorName,
            email: nil,
            phonenumber: nil
        )
        
        if let robot = fragment.robot?.fragments.robotFragment {
            self.robot = .init(robot)
        } else {
            self.robot = nil
        }
        
        let currentServiceUnitIdx = fragment.currentServiceUnitStep ?? 0
        self.currentServiceUnitIdx = currentServiceUnitIdx
        var serviceUnits = fragment.serviceUnits?
            .compactMap { $0?.fragments.serviceUnitFragment }
            .map { fragment -> ServiceUnit in
                var serviceUnit = ServiceUnit(fragment)
                serviceUnit.isInProgress = (serviceUnit.orderWithinService == currentServiceUnitIdx)
                return serviceUnit
            } ?? []
        serviceUnits = serviceUnits.filter { $0.orderWithinService > 0 }.sorted { $0.orderWithinService < $1.orderWithinService }
        if let timestamps = fragment.timestamps?.toDictionaries {
            self.serviceLogSet = .init(jsonList: timestamps, with: serviceUnits, creator: self.creator, robot: self.robot)
        } else {
            self.serviceLogSet = .init(serviceLogs: [])
        }
        
        //목적지에 로봇이 도착한 시간 입력
        for index in 0..<serviceUnits.count {
            guard let targetLog = self.serviceLogSet.serviceLogs.first(where: {
                guard case .robotArrived(let serviceUnitIdx, _) = $0.type else { return false }
                return (serviceUnits[index].orderWithinService == serviceUnitIdx)
            }) else { continue }
            serviceUnits[index].robotArrivalTime = targetLog.date
        }
        self.serviceUnits = serviceUnits
        
        self.requestedAt = fragment.createdAt
        self.startedAt = self.serviceLogSet.startedAt
        self.finishedAt = self.serviceLogSet.finishedAt
        
        if let phase = fragment.phase {
            self.phase = .init(phase: phase, state: self.status, logset: self.serviceLogSet)
        } else {
            self.phase = .waiting
        }
        
        self.travelDistance = fragment.totalMovingDistance
    }
    
    init(option fragment: ServiceFragment?) {
        
        self.id = fragment?.id ?? Self.unknownId
        
        if let type = fragment?.type {
            self.type = .init(rawValue: type) ?? .general
        } else {
            self.type = .unknown
        }
        
        if let state = fragment?.state {
            self.status = .init(state: state)
        } else {
            self.status = .unknown
        }
        
        self.serviceNumber = fragment?.serviceNumber ?? "-"
        
        let creatorInfo = fragment?.creator?.toDictionary
        let username = (creatorInfo?["id"] as? String) ?? User.unknownName
        let creatorName = (creatorInfo?["name"] as? String) ?? "알 수 없는 유저"
        self.creator = .init(
            id: User.unknownId,
            username: username,
            displayName: creatorName,
            email: nil,
            phonenumber: nil
        )
        
        if let robot = fragment?.robot?.fragments.robotFragment {
            self.robot = .init(robot)
        } else {
            self.robot = nil
        }
        
        let currentServiceUnitIdx = fragment?.currentServiceUnitStep ?? 0
        self.currentServiceUnitIdx = currentServiceUnitIdx
        var serviceUnits = fragment?.serviceUnits?
            .compactMap { $0?.fragments.serviceUnitFragment }
            .map { fragment -> ServiceUnit in
                var serviceUnit = ServiceUnit(fragment)
                serviceUnit.isInProgress = (serviceUnit.orderWithinService == currentServiceUnitIdx)
                return serviceUnit
            } ?? []
        serviceUnits = serviceUnits.filter { $0.orderWithinService > 0 }.sorted { $0.orderWithinService < $1.orderWithinService }
        if let timestamps = fragment?.timestamps?.toDictionaries {
            self.serviceLogSet = .init(jsonList: timestamps, with: serviceUnits, creator: self.creator, robot: self.robot)
        } else {
            self.serviceLogSet = .init(serviceLogs: [])
        }
        
        //목적지에 로봇이 도착한 시간 입력
        for index in 0..<serviceUnits.count {
            guard let targetLog = self.serviceLogSet.serviceLogs.first(where: {
                guard case .robotArrived(let serviceUnitIdx, _) = $0.type else { return false }
                return (serviceUnits[index].orderWithinService == serviceUnitIdx)
            }) else { continue }
            serviceUnits[index].robotArrivalTime = targetLog.date
        }
        self.serviceUnits = serviceUnits
        
        self.requestedAt = fragment?.createdAt ?? Date()
        self.startedAt = self.serviceLogSet.startedAt
        self.finishedAt = self.serviceLogSet.finishedAt
        
        if let phase = fragment?.phase {
            self.phase = .init(phase: phase, state: self.status, logset: self.serviceLogSet)
        } else {
            self.phase = .waiting
        }
        
        self.travelDistance = fragment?.totalMovingDistance
    }
}

extension Service {
    
    init(_ fragment: ServiceRawFragment) {
        
        self.id = fragment.id
        
        if let type = fragment.type {
            self.type = .init(rawValue: type) ?? .general
        } else {
            self.type = .unknown
        }
        
        if let state = fragment.serviceState {
            self.status = .init(state: state)
        } else {
            self.status = .unknown
        }
        
        self.serviceNumber = fragment.serviceNumber
        
        let creatorInfo = fragment.creator?.toDictionary
        let username = (creatorInfo?["id"] as? String) ?? User.unknownName
        let creatorName = (creatorInfo?["name"] as? String) ?? "알 수 없는 유저"
        self.creator = .init(
            id: User.unknownId,
            username: username,
            displayName: creatorName,
            email: nil,
            phonenumber: nil
        )
        
        if let robot = fragment.robot?.fragments.robotRawFragment {
            self.robot = .init(robot)
        } else {
            self.robot = nil
        }
        
        let currentServiceUnitIdx = fragment.currentServiceUnitStep
        self.currentServiceUnitIdx = currentServiceUnitIdx
        var serviceUnits = fragment.serviceUnits
            .compactMap { $0.fragments.serviceUnitRawFragment }
            .map { fragment -> ServiceUnit in
                var serviceUnit = ServiceUnit(fragment)
                serviceUnit.isInProgress = (serviceUnit.orderWithinService == currentServiceUnitIdx)
                return serviceUnit
            }
        serviceUnits = serviceUnits.filter { $0.orderWithinService > 0 }.sorted { $0.orderWithinService < $1.orderWithinService }
        if let timestamps = fragment.timestamps.toDictionaries {
            self.serviceLogSet = .init(jsonList: timestamps, with: serviceUnits, creator: self.creator, robot: self.robot)
        } else {
            self.serviceLogSet = .init(serviceLogs: [])
        }
        
        //목적지에 로봇이 도착한 시간 입력
        for index in 0..<serviceUnits.count {
            guard let targetLog = self.serviceLogSet.serviceLogs.first(where: {
                guard case .robotArrived(let serviceUnitIdx, _) = $0.type else { return false }
                return (serviceUnits[index].orderWithinService == serviceUnitIdx)
            }) else { continue }
            serviceUnits[index].robotArrivalTime = targetLog.date
        }
        self.serviceUnits = serviceUnits
        
        self.requestedAt = fragment.createdAt
        self.startedAt = self.serviceLogSet.startedAt
        self.finishedAt = self.serviceLogSet.finishedAt
        
        if let phase = fragment.phase {
            self.phase = .init(phase: phase, state: self.status, logset: self.serviceLogSet)
        } else {
            self.phase = .waiting
        }
        
        self.travelDistance = fragment.totalMovingDistance
    }
}

extension Service {
    
    var canceledDescription: String? {
        switch self.status {
        case .canceled:
            let defaultMessage = "관리자가 서비스를 취소하였습니다."
            return self.serviceLogSet.canceledMessage ?? defaultMessage
        case .failed:
            let defaultMessage = "알 수 없는 오류로 서비스가 취소되었습니다."
            return self.serviceLogSet.failedMessage ?? defaultMessage
        case .returning:
            if self.serviceLogSet.isServiceCanceled {
                return self.serviceLogSet.canceledMessage
            } else if self.serviceLogSet.isServiceFailed {
                return self.serviceLogSet.failedMessage
            }
        default:
            break
        }
        return nil
    }
    
    var stateDescription: String {
        switch self.status {
        case .finished:
            return "서비스 완료"
        case .canceled, .failed:
            return "서비스 취소"
        case .returning:
            if self.serviceLogSet.isServiceCompleted {
                return "서비스 완료"
            } else {
                return "서비스 취소"
            }
        default:
            if self.currentServiceUnitIdx == 0 {
                return "로봇 배정 중"
            } else if self.currentServiceUnitIdx <= self.serviceUnits.count {
                switch self.status {
                case .waiting:
                    return "출발 준비 중"
                case .moving:
                    return "이동 중"
                case .arrived:
                    return "정차지 도착"
                default:
                    return "(알수없음)"
                }
            } else {
                return "(알수없음)"
            }
        }
    }
    
    var stateColor: UIColor {
        switch self.status {
        case .finished:
            return .init(hex: "#F5F5F5")
        case .canceled, .failed:
            return .init(hex: "#F8CECC")
        case .returning:
            if self.serviceLogSet.isServiceCompleted {
                return .init(hex: "#F5F5F5")
            } else {
                return .init(hex: "#F8CECC")
            }
        default:
            if self.currentServiceUnitIdx == 0 {
                return .white
            } else if self.currentServiceUnitIdx <= self.serviceUnits.count {
                switch self.status {
                case .waiting:
                    return .init(hex: "#FFF2CC")
                case .moving:
                    return .init(hex: "#DAE8FC")
                case .arrived:
                    return .init(hex: "#DAE8FC")
                default:
                    return .white
                }
            } else {
                return .white
            }
        }
    }
}

extension Service {
    
    //내가 작업할 차례 여부
    func isMyTurn(_ id: String?) -> Bool {
        //작업대기 상태이면서 현재 진행중 단위서비스의 작업자
        guard self.status == .arrived,
              let currentServiceUnit = self.serviceUnits.first(where: {
                  $0.orderWithinService == self.currentServiceUnitIdx
              }) else { return false }
        return currentServiceUnit.isMyWork(id)
    }
    
    var currentServiceUnit: ServiceUnit? {
        return self.serviceUnits.first { $0.orderWithinService == self.currentServiceUnitIdx }
    }
}

extension Service: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.type)
        hasher.combine(self.status)
        hasher.combine(self.phase)
        hasher.combine(self.serviceNumber)
        hasher.combine(self.requestedAt)
        hasher.combine(self.startedAt)
        hasher.combine(self.finishedAt)
        hasher.combine(self.robot)
        hasher.combine(self.creator)
        hasher.combine(self.serviceUnits)
        hasher.combine(self.currentServiceUnitIdx)
        hasher.combine(self.travelDistance)
        hasher.combine(self.serviceLogSet)
    }
}
