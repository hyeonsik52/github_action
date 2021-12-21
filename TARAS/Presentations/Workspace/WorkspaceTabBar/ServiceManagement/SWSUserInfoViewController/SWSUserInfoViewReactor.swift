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
        case loadedUserInfo(User?)
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
    }
    
    struct State {
        var userInfo: User?
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(userInfo: nil)
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    let userId: String
    
    init(provider: ManagerProviderType, workspaceId: String, userId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.userId = userId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return .concat([
                .just(.isLoading(true)),
                
//                self.provider.networkManager.fetch(UserByIdQuery(workspaceId: self.workspaceId))
//                    .compactMap { $0.signedUser?.joinedWorkspaces?.edges.compactMap { $0?.node }.first }
//                    .compactMap { $0.members?.edges.compactMap { $0?.node }.first }
//                    .compactMap { $0.fragments.memberFragment }
//                    .map { .loadedUserInfo(.init(member: $0)) },
                
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
}
