//
//  ServiceUnitCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class ServiceUnitCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var serviceSet: ServiceUnitModelSet
    }
    
    var initialState: State
    
    init(serviceSet: ServiceUnitModelSet) {
        self.initialState = State(serviceSet: serviceSet)
    }
}
