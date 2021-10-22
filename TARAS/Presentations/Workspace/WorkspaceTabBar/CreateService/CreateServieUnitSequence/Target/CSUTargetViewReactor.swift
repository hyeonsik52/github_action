//
//  CSUTargetViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import Apollo
import ReactorKit

/// CSU 는 Create Service Unit(단위서비스 생성) 의 약자입니다.
class CSUTargetViewReactor: Reactor {
    
    enum Action {
        case setInitialPage
    }
    
    enum Mutation {
        case updateInitialPage
    }
    
    struct State {
    }
    
    var initialState: State {
        return .init()
    }
    
    let provider: ManagerProviderType
    
    let workspaceId: String
    
    var serviceUnitModel: CreateServiceUnitModel?
    
    init(provider: ManagerProviderType, workspaceId: String, serviceUnitModel: CreateServiceUnitModel?) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceUnitModel = serviceUnitModel
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setInitialPage:
            return .just(.updateInitialPage)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateInitialPage:
            print()
        }
        return state
    }
    
    func reactorForTargetStop() -> TargetStopViewReactor {
        return TargetStopViewReactor(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnitModel: self.serviceUnitModel
        )
    }

    func reactorForRecipients(
        _ serviceUnitModel: CreateServiceUnitModel
    ) -> CSURecipientViewReactor? {
        return CSURecipientViewReactor(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnitModel: serviceUnitModel
        )
    }
}
