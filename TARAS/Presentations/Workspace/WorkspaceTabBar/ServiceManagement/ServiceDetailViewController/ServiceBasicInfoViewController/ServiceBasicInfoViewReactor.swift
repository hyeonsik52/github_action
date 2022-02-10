//
//  ServiceBasicInfoViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class ServiceBasicInfoViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case refreshService(Service?)
        case updateIsLoading(Bool?)
    }
    
    struct State {
        var service: Service?
        var isLoading: Bool?
    }
    
    var initialState: State = .init(
        service: nil,
        isLoading: nil
    )
    
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
                .just(.updateIsLoading(true)),
                
                self.provider.networkManager.fetch(query)
                    .map { $0.signedUser?.joinedWorkspaces?.edges.first??.node }
                    .map { $0?.services?.edges.first??.node?.fragments.serviceFragment }
                    .map { .refreshService(.init(option: $0)) },
                
                .just(.updateIsLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .refreshService(let service):
            state.service = service
        case .updateIsLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
