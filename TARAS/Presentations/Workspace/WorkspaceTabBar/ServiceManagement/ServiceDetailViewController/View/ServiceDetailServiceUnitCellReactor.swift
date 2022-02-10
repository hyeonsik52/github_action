//
//  ServiceDetailServiceUnitCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

enum ServiceUnitRobotArrivalState {
    case waiting
    case departure
    case arrival
    case passed
}

class ServiceDetailServiceUnitCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var serviceUnit: ServiceUnit
        var isMyWork: Bool
        var isServiceInProgress: Bool
        var isServicePreparing: Bool
        var robotArrivalState: ServiceUnitRobotArrivalState
    }
    
    var initialState: State
    var isLastCell: Bool = false
    
    init(
        serviceUnit: ServiceUnit,
        userId: String?,
        isServiceInProgress: Bool,
        isServicePreparing: Bool,
        robotArrivalState: ServiceUnitRobotArrivalState
    ) {
        let isMyWork = serviceUnit.isMyWork(userId)
        self.initialState = .init(
            serviceUnit: serviceUnit,
            isMyWork: isMyWork,
            isServiceInProgress: isServiceInProgress,
            isServicePreparing: isServicePreparing,
            robotArrivalState: robotArrivalState
        )
    }
}
