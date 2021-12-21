//
//  WorkspaceInfoViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class WorkspaceInfoViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case loadSwsInfo
    }
    
    enum Mutation {
        case loadedSwsInfo(Workspace?)
        case setLoading(Bool?)
    }
    
    struct State {
        var workspace: Workspace?
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(workspace: nil, isLoading: nil)
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    
    init(provider: ManagerProviderType, workspaceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadSwsInfo:
            return .concat([
                .just(.setLoading(true)),
                
                self.provider.networkManager
                    .fetch(WorkspaceByIdQuery(id: self.workspaceId))
                    .compactMap(\.signedUser?.joinedWorkspaces?.edges.first)
                    .compactMap(\.?.node?.fragments.workspaceFragment)
                    .map{ Mutation.loadedSwsInfo(.init($0)) },
                
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedSwsInfo(workspace):
            state.workspace = workspace
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
