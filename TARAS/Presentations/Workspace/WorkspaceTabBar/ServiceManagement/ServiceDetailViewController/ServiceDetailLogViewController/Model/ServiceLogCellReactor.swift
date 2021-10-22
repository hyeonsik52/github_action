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
    
    var initialState: ServiceLog?
    
    let provider : ManagerProviderType
    let workspaceId: String
    
    init(model: ServiceLog, provider: ManagerProviderType, workspaceId: String) {
        self.initialState = model
        self.provider = provider
        self.workspaceId = workspaceId
    }
}
