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
        case loadedService(ServiceModel?)
        case setLoading(Bool?)
    }
    
    struct State {
        var service: ServiceModel?
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(service: nil, isLoading: nil)
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    let serviceIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int, serviceIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceIdx = serviceIdx
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                
                self.provider.networkManager
                    .fetch(ServiceByServiceIdxQuery(swsIdx: self.swsIdx, serviceIdx: self.serviceIdx))
                    .compactMap { $0.serviceByServiceIdx.asService }
                    .map { ServiceModel($0, with: self.provider.serviceManager) }
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
    
    func reactorForSwsUserInfo(userIdx: Int) -> SWSUserInfoViewReactor {
        return SWSUserInfoViewReactor(provider: self.provider, swsIdx: self.swsIdx, userIdx: userIdx)
    }
}
