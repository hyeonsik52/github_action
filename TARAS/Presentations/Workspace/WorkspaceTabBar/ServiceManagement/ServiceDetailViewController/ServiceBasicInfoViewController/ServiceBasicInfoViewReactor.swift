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
        case loadedService(Service?)
        case setLoading(Bool?)
    }
    
    struct State {
        var service: Service?
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(
            service: nil,
            isLoading: nil
        )
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
            return .concat([
                .just(.setLoading(true)),
                
                self.provider.networkManager
                    .fetch(ServiceQuery(serviceId: self.serviceId))
                    .compactMap { $0.hiGlovisServiceByOrderId?.fragments.serviceFragment }
                    .map { self.provider.serviceManager.convert(service: $0) }
                    .map { Mutation.loadedService($0) },
                
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedService(service):
            state.service = service
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
    
    func reactorForSwsUserInfo(userId: String) -> SWSUserInfoViewReactor {
        return SWSUserInfoViewReactor(provider: self.provider, workspaceId: self.workspaceId, userId: userId)
    }
}
