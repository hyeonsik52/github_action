//
//  ServiceLogCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class ServiceLogCellReactor: Reactor {
    typealias Action = NoAction
    
    var initialState: ServiceLog
    
    init(model: ServiceLog) {
        self.initialState = model
    }
}
