//
//  CSUMessageViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class CSUMessageViewReactor: Reactor {
    
    enum Action {
        case setMessage(String)
    }
    
    enum Mutation {
        case updateMessage(String)
    }
    
    struct State {
        var message: String?
    }
    
    var initialState: State {
        return .init(message: nil)
    }
    
    let provider : ManagerProviderType
    
    let workspaceId: String
    
    var serviceUnitModel: CreateServiceUnitModel
    
    init(provider: ManagerProviderType, workspaceId: String, serviceUnitModel: CreateServiceUnitModel) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceUnitModel = serviceUnitModel
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setMessage(message):
            return .just(.updateMessage(message))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateMessage(message):
            state.message = message
            return state
        }
    }
}
