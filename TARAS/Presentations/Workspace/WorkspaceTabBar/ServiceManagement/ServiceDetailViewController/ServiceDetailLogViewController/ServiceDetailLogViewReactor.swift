//
//  ServiceDetailLogViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class ServiceDetailLogViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case refreshServiceLogs([ServiceLog])
        case isLoading(Bool?)
    }
    
    struct State {
        var serviceLogs: [ServiceLog]
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(serviceLogs: [], isLoading: nil)
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    let serviceId: String
    
    init(provider: ManagerProviderType, workspaceId: String, serviceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceId = serviceId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let query = ServiceQuery(workspaceId: self.workspaceId, serviceId: self.serviceId)
            return .concat([
                .just(.isLoading(true)),
                
                self.provider.networkManager.fetch(query)
                    .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node }
                    .compactMap { $0.services?.edges.first??.node?.fragments.serviceFragment }
                    .map { Service($0).serviceLogSet.serviceLogs }
                    .map { .refreshServiceLogs($0) },
                
                .just(.isLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .refreshServiceLogs(let serviceLogs):
            state.serviceLogs = serviceLogs
        case .isLoading(let loading):
            state.isLoading = loading
        }
        return state
    }
}
