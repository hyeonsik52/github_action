//
//  WorkspaceTabBarControllerReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/25.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class WorkspaceTabBarControllerReactor: Reactor {
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
    
    //TODO: 워크스페이스 - 서비스 요청
    func reactorForWorkspaceHome() -> WorkspaceHomeReactor {
        return WorkspaceHomeReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            pushInfo: self.pushInfo
        )
    }
    
    //TODO: 워크스페이스 - 내 서비스
    func reactorForMyServices() -> ServiceManagementViewReactor {
        return ServiceManagementViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            pushInfo: self.pushInfo
        )
    }
    
    //TODO: 워크스페이스  - 더보기
    func reactorForMore() -> WorkspaceMoreViewReactor {
        return WorkspaceMoreViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
}
