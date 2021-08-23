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
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setJoinState(JoinStateType)
        case setJoinResult(Result<Bool, Error>)
        case setCancelResult(Result<Bool, Error>)
        case setEnterResult(Bool)
    }
    
    struct State {
        var joinState: JoinStateType
        var cellModel: WorkspaceListCellModel
        var errorMessage: String?
        var isLoading: Bool
        var requestResult: Bool
        var cancelResult: Bool
        var enterResult: Bool
    }
    
    let provider: ManagerProviderType
    let initialState: State
    
    init(provider: ManagerProviderType, workspaceListCellModel: WorkspaceListCellModel) {
        self.provider = provider
        
        self.initialState = State(
            joinState: .none,
            cellModel: workspaceListCellModel,
            errorMessage: nil,
            isLoading: false,
            requestResult: false,
            cancelResult: false,
            enterResult: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                    .just(.setLoading(true)),
                    self.provider.workspaceManager
                        .joinState(for: self.currentState.cellModel.swsIdx)
                        .map { Mutation.setJoinState($0) },
                    .just(.setLoading(false))
                ])

        case .requestJoin:
            switch self.currentState.joinState {
            case .none:
                return .empty()
                
            case .new:
                return .concat([
                    .just(.setLoading(true)),
                    self.provider.workspaceManager
                        .requestJoinWorkspace(with: self.currentState.cellModel.swsIdx)
                        .map { Mutation.setJoinResult($0) },
                    .just(.setLoading(false))
                ])
                
            case .requested:
                return .concat([
                    .just(.setLoading(true)),
                    self.provider.workspaceManager
                        .workspacesRequested()
                        .flatMap { workspaces -> Observable<Mutation> in
                            let matched = workspaces
                                .filter { $0.node?.swsIdx == self.currentState.cellModel.swsIdx }
                                .first

                            guard let requestIdx = matched?.node?.swsJoinRequestIdx else { return .empty() }

                            return self.provider.workspaceManager
                                .cancelJoinWorkspace(with: requestIdx)
                                .map { Mutation.setCancelResult($0) }
                    },
                    .just(.setLoading(false))
                ])
                
            case .joined:
                return .just(.setEnterResult(true))
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setJoinState(joinState):
            state.cellModel.joinState = joinState
            state.joinState = joinState
            return state
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case let .setJoinResult(result):
            switch result {
            case .success:
                state.errorMessage = nil
                state.requestResult = true
                return state
                
            case let .failure(error):
                if let err = error as? RequestJoinSWSErrorCode {
                    state.errorMessage = err.description
                    return state
                }
                
                state.errorMessage = "네트워크/서버 연결이 원할하지 않습니다. 잠시 후 다시 시도해주세요."
                return state
            }
            
        case let .setCancelResult(result):
            switch result {
            case .success:
                state.errorMessage = nil
                state.cancelResult = true
                return state
                
            case let .failure(error):
                if let err = error as? CancelSWSJoinRequestErrorCode {
                    state.errorMessage = err.description
                    return state
                }
                
                state.errorMessage = "네트워크/서버 연결이 원할하지 않습니다. 잠시 후 다시 시도해주세요."
                return state
            }
            
        case let .setEnterResult(result):
            state.enterResult = result
            return state
        }
    }

    func reactorForResult() -> SignInViewReactor {
        return SignInViewReactor(provider: self.provider)
    }
    
    func reactorForSWSHome(swsIdx: Int) -> WorkspaceTabBarControllerReactor {
        return WorkspaceTabBarControllerReactor(provider: self.provider, swsIdx: swsIdx)
    }
}
