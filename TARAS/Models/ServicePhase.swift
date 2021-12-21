//
//  ServicePhase.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

enum ServicePhase: Int {
    ///배송 대기
    case waiting
    ///배송 중
    case delivering
    ///배송 완료
    case completed
    
    ///배송 취소
    case canceled
    case all
    
    init(phase: String, state: ServiceState, logset: ServiceLogSet) {
        switch phase {
        case "Initialization":
            self = .waiting
        case "Executing":
            self = .delivering
        case "Done":
            switch state {
            case .finished:
                self = .completed
            case .canceled, .failed:
                self = .canceled
            case .returning:
                if logset.isServiceCompleted {
                    self = .completed
                } else {
                    self = .canceled
                }
            default:
                self = .all
            }
        default:
            self = .all
        }
    }
    
    var toString: String? {
        switch self {
        case .waiting:
            return "Initialization"
        case .delivering:
            return "Executing"
        case .completed, .canceled:
            return "Done"
        default:
            return nil
        }
    }
}

extension ServicePhase {
    
    //대기, 진행 상태가 완료, 취소보다 정렬 우선 순위를 가짐
    var sortOrder: Int {
        switch self {
        case .all:
            return 2
        case .waiting, .delivering:
            return 1
        case .completed, .canceled:
            return 0
        }
    }
}

extension ServicePhase {
    
    static var menuAll: [Self] {
        return [.all, .waiting, .delivering, .completed, .canceled]
    }
}
