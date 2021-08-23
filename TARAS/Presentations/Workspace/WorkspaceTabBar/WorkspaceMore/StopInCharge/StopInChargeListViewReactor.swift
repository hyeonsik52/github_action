//
//  StopInChargeListViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class StopInChargeListViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case loadedUserInfo(UserInfo?)
        case setLoading(Bool?)
    }
    
    struct State {
        var userInfo: UserInfo?
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(userInfo: nil, isLoading: nil)
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    let userIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int, userIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.userIdx = userIdx
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                self.provider.networkManager
                    .fetch(UserByUserIdxQuery(userIdx: self.userIdx, swsIdx: self.swsIdx))
                    .compactMap { UserInfo($0.userByUserIdx.asUser) }
                    .map { Mutation.loadedUserInfo($0) },
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedUserInfo(userInfo):
            state.userInfo = userInfo
        case let .setLoading(loading):
            state.isLoading = loading
        }
        return state
    }
}
