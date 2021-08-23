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
    
    var initialState: ServiceLogModel?
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    init(model: ServiceLogModel, provider: ManagerProviderType, swsIdx: Int) {
        self.initialState = model
        self.provider = provider
        self.swsIdx = swsIdx
    }
}
