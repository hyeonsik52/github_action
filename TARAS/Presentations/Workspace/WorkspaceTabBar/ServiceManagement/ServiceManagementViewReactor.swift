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
    let swsIdx: Int
    let pushInfo: NotificationInfomation?
    
    init(provider: ManagerProviderType, swsIdx: Int, pushInfo: NotificationInfomation? = nil) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.pushInfo = pushInfo
    }
    
    func reactorForServiceDetail(mode: ServiceDetailViewReactor.Mode, serviceIdx: Int) -> ServiceDetailViewReactor {
        return ServiceDetailViewReactor(mode: mode, provider: self.provider, swsIdx: self.swsIdx, serviceIdx: serviceIdx)
    }
    
    func reactorForReceivedServices() -> PagingReceivedServicesViewReactor {
        return PagingReceivedServicesViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    func reactorForCreatedServices() -> PagingCreatedServicesViewReactor {
        return PagingCreatedServicesViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
}
