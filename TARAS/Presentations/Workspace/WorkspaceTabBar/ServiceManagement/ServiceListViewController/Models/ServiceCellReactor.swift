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
    
    struct State {
        var service: Service
        var isMyTurn: Bool
    }
    
    let initialState: State
    
    init(service: Service, myUserId: String?) {
        let isMyTurn = service.isMyTurn(myUserId)
        self.initialState = .init(service: service, isMyTurn: isMyTurn)
    }
}
