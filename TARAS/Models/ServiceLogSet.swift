//
//  ServiceLogSet.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

struct ServiceLogSet {
    
    ///서비스 진행 기록
    let serviceLogs: [ServiceLog]
}

extension ServiceLogSet {
    
    init(jsonList: [[String: Any]], with serviceUnits: [ServiceUnit], creator: User, robot: Robot?) {
        self.serviceLogs = jsonList
            .compactMap { ServiceLog(json: $0, with: serviceUnits, creator: creator, robot: robot) }
            .sorted { $0.date < $1.date }
            .filter {
                if case .unclassified = $0.type {
                    return false
                } else {
                    return true
                }
            }
    }
}

extension ServiceLogSet {
    
    var requestedAt: Date? {
        self.serviceLogs.last {
            switch $0.type {
            case .created: return true
            default: return false
            }
        }?.date
    }
    
    var startedAt: Date? {
        self.serviceLogs.last {
            switch $0.type {
            case .robotAssigned: return true
            default: return false
            }
        }?.date
    }
    
    var finishedAt: Date? {
        self.serviceLogs.first {
            switch $0.type {
            case .finished, .canceled, .failed: return true
            default: return false
            }
        }?.date
    }
}

extension ServiceLogSet {
    
    ///* 서비스가 종료되어 로봇이 복귀할 때 서비스가 정상 종료되었는 지 판단
    var isServiceCompleted: Bool {
        return (self.serviceLogs.first {
            guard case .finished = $0.type else { return false }
            return true
        } != nil)
    }
    
    var isServiceCanceled: Bool {
        return (self.canceledServiceLog != nil)
    }
    
    var canceledMessage: String? {
        return self.canceledServiceLog?.type.message
    }
    
    var canceledServiceLog: ServiceLog? {
        return self.serviceLogs.first {
            guard case .canceled = $0.type else { return false }
            return true
        }
    }
    
    var failedMessage: String? {
        return self.failedServiceLog?.type.message
    }
    
    var isServiceFailed: Bool {
        return (self.failedServiceLog != nil)
    }
    
    var failedServiceLog: ServiceLog? {
        return self.serviceLogs.first {
            guard case .failed(_) = $0.type else { return false }
            return true
        }
    }
}

extension ServiceLogSet: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.serviceLogs)
    }
}
