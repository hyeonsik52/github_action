//
//  SWSUserInfoViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class SWSUserInfoViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case loadedUserInfo(UserInfo?)
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
    }
    
    struct State {
        var userInfo: UserInfo?
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(userInfo: nil)
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
                .just(.isLoading(true)),
                
                self.provider.networkManager
                    .fetch(UserByUserIdxQuery(userIdx: self.userIdx, swsIdx: self.swsIdx))
                    .compactMap { UserInfo($0.userByUserIdx.asUser) }
                    .map { Mutation.loadedUserInfo($0) },
                
                .just(.isLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedUserInfo(userInfo):
            state.userInfo = userInfo
        case .isLoading(let loading):
            state.isLoading = loading
        }
        return state
    }
    
    func reactorForBelongingGroup() -> BelongingGroupListViewReactor {
        return BelongingGroupListViewReactor(provider: self.provider, swsIdx: self.swsIdx, userIdx: self.userIdx)
    }
    
    func reactorForStopInCharge() -> StopInChargeListViewReactor {
        return StopInChargeListViewReactor(provider: self.provider, swsIdx: self.swsIdx, userIdx: self.userIdx)
    }
}
