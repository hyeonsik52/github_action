//
//  ServiceManagementViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/25.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class ServiceManagementViewReactor: Reactor {
    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State { }
    
    var initialState: State {
        return .init()
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    let pushInfo: NotificationInfo?
    
    init(provider: ManagerProviderType, workspaceId: String, pushInfo: NotificationInfo? = nil) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.pushInfo = pushInfo
    }
    
    func reactorForServiceDetail(serviceId: String) -> ServiceDetailViewReactor {
        return ServiceDetailViewReactor(provider: self.provider, workspaceId: self.workspaceId, serviceId: serviceId)
    }
    
    func reactorForReceivedServices() -> PagingReceivedServicesViewReactor {
        return PagingReceivedServicesViewReactor(provider: self.provider, workspaceId: self.workspaceId)
    }
}
