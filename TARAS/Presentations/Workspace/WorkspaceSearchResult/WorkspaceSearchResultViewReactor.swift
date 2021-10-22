//
//  WorkspaceSearchResultViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/26.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class WorkspaceSearchResultViewReactor: Reactor {
    
    enum Text {
        static let SIVR_1 = "아이디, 비밀번호 regex 오류"
    }

    enum Action {
        case refresh
        case requestJoin
        case cancelRequest
    }
    
    enum Mutation {
        case setWorkspace(Workspace)
        case setLoading(Bool)
        case setJoinResult(Bool?)
        case setCancelResult(Bool?)
        case setError(String?)
    }
    
    struct State {
        var workspace: Workspace?
        var isLoading: Bool
        var requestResult: Bool?
        var cancelResult: Bool?
        var errorMessage: String?
    }
    
    let initialState: State
    
    let provider: ManagerProviderType
    let workspaceCode: String
    
    init(provider: ManagerProviderType, workspaceCode: String) {
        self.provider = provider
        self.workspaceCode = workspaceCode
        
        self.initialState = State(
            workspace: nil,
            isLoading: false,
            requestResult: false,
            cancelResult: false,
            errorMessage: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                self.provider.networkManager
                    .fetch(SearchWorkspaceByCodeQuery(code: self.workspaceCode))
                    .compactMap(\.linkedWorkspaces?.edges.first)
                    .compactMap(\.?.node?.fragments.workspaceFragment)
                    .map { .setWorkspace(.init($0)) },
                .just(.setLoading(false))
            ])
            
        case .requestJoin:
            guard let worksapceId = self.currentState.workspace?.id else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
                self.provider.networkManager
                    .perform(RequestToJoinWorkspaceMutation(workspaceId: worksapceId))
                    .compactMap(\.requestToJoinWorkspace)
                    .map { .setJoinResult($0) },
                .just(.setLoading(false))
            ])
        case .cancelRequest:
            guard let worksapceId = self.currentState.workspace?.id else { return .empty() }
            return .concat([
                .just(.setLoading(true)),
                self.provider.networkManager
                    .perform(CancelToJoinWorkspaceMutation(workspaceId: worksapceId))
                    .compactMap(\.cancelToJoinWorkspace)
                    .map { .setCancelResult($0) },
                .just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setWorkspace(workspace):
            state.workspace = workspace
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .setJoinResult(result):
            state.requestResult = result
            state.errorMessage = (result == true ? nil: "")
            
        case let .setCancelResult(result):
            state.cancelResult = result
            state.errorMessage = (result == true ? nil: "")
            
        case let .setError(message):
            state.errorMessage = message
        }
        return state
    }

    func reactorForResult() -> SignInViewReactor {
        return SignInViewReactor(provider: self.provider)
    }
    
    func reactorForSWSHome(workspaceId: String) -> WorkspaceTabBarControllerReactor {
        return WorkspaceTabBarControllerReactor(provider: self.provider, workspaceId: workspaceId)
    }
}
