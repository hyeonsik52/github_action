//
//  ServiceCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class ServiceCellReactor: Reactor {
    typealias Action = NoAction
    
    enum SerciceCellVisibleMode {
        case homeSended
        case homeSendedDetail
        case homeReceivedDetail
        case managementReceived
        case managementCreated
    }
    
    struct State {
        var service: ServiceModel
        var serviceUnit: ServiceUnitModel?
        var serviceUnitOffset: Int?
    }
    
    let initialState: State
    
    let mode: SerciceCellVisibleMode
    
    init(mode: SerciceCellVisibleMode, service: ServiceModel, serviceUnit: ServiceUnitModel? = nil, serviceUnitOffset: Int? = nil) {
        self.initialState = State(service: service, serviceUnit: serviceUnit, serviceUnitOffset: serviceUnitOffset)
        self.mode = mode
    }
}

extension ServiceCellReactor: Hashable {
    
    static func == (lhs: ServiceCellReactor, rhs: ServiceCellReactor) -> Bool {
        return (lhs.currentState.serviceUnit?.serviceUnitIdx == rhs.currentState.serviceUnit?.serviceUnitIdx)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.currentState.serviceUnit?.serviceUnitIdx)
    }
}
