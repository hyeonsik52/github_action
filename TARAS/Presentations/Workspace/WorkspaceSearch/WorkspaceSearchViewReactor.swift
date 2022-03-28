//
//  WorkspaceSearchViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class WorkspaceSearchViewReactor: Reactor {
    
    enum Action: Equatable {
        case updateIsInitialOpen
        case updateCode(String)
        case confirmCode
    }
    
    enum Mutation {
        case setCode(String)
        case setLoading(Bool)
        case setError(String?)
        case setResult(Workspace)
    }
    
    struct State {
        var code: String?
        var errorMessage: String?
        var isLoading: Bool
        var workspaceInfo: Workspace?
    }
    
    let provider: ManagerProviderType
    let initialState: State
    
    init(provider: ManagerProviderType) {
        self.provider = provider
        self.initialState = State(
            code: nil,
            errorMessage: nil,
            isLoading: false,
            workspaceInfo: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateCode(code):
            return .just(.setCode(code))
            
        case .confirmCode:
            guard let code = self.currentState.code,
                self.currentState.errorMessage == nil else {
                    return .empty()
            }

            let query = WorkspaceByCodeQuery(code: code)
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                
                self.provider.networkManager.fetch(query)
                    .flatMapLatest { data -> Observable<Mutation> in
                        guard let edge = data.workspaces?.edges.first,
                              let fragment = edge?.node?.fragments.onlyWorkspaceFragment else {
                                  return .just(.setError("입력한 코드와 일치하는 워크스페이스가 없습니다."))
                              }
                        return .just(.setResult(.init(only: fragment)))
                    },
                
                .just(.setLoading(false))
            ])
            
        case .updateIsInitialOpen:
            let isInitialOpen = self.provider.userManager.userTB.isInitialOpen
            if isInitialOpen {
                self.provider.userManager.userTB.update {
                    $0.isInitialOpen = false
                }
            }
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setCode(code):
            state.code = code
            state.errorMessage = nil
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            state.workspaceInfo = nil
            
        case let .setError(message):
            state.errorMessage = message
            
        case let .setResult(result):
            state.workspaceInfo = result
        }
        return state
    }

    func reactorForResult() -> WorkspaceSearchResultViewReactor? {
        guard let code = self.currentState.workspaceInfo?.code else { return nil }
        return WorkspaceSearchResultViewReactor(
            provider: self.provider,
            workspaceCode: code
        )
    }
}
