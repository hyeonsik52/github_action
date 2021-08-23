//
//  BelongingGroupListViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class BelongingGroupListViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case loadedUserInfo(SWSUserInfo?)
        case setLoading(Bool?)
    }
    
    struct State {
        var swsUserInfo: SWSUserInfo?
        var isLoading: Bool?
    }
    
    var initialState: State {
        return .init(swsUserInfo: nil, isLoading: nil)
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    //nil일 경우 내 정보
    let userIdx: Int?
    
    init(provider: ManagerProviderType, swsIdx: Int, userIdx: Int? = nil) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.userIdx = userIdx
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            if let userIdx = self.userIdx {
                return .concat([
                    .just(.setLoading(true)),
                    
                    self.provider.networkManager
                        .fetch(UserByUserIdxQuery(userIdx: userIdx, swsIdx: self.swsIdx))
                        .map{ UserInfo($0.userByUserIdx.asUser)?.swsUserInfo }
                        .map{ Mutation.loadedUserInfo($0) },
                    
                    .just(.setLoading(false))
                ])
            }else{
                return .concat([
                    .just(.setLoading(true)),
                    
                    self.provider.networkManager
                        .fetch(MyUserInfoQuery(swsIdx: self.swsIdx))
                        .map{ UserInfo($0.myUserInfo.asUser)?.swsUserInfo }
                        .map{ Mutation.loadedUserInfo($0) },
                    
                    .just(.setLoading(false))
                ])
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedUserInfo(info):
            state.swsUserInfo = info
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
