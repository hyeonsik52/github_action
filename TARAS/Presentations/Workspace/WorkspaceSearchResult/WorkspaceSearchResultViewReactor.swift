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
        case request
    }
    
    enum Mutation {
        case setWorkspace(Workspace)
        case setLoading(Bool)
        case setResult(Bool?)
        case setError(String?)
    }
    
    struct State {
        var workspace: Workspace?
        var isLoading: Bool
        var result: Bool?
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
            result: nil,
            errorMessage: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        let userId = self.provider.userManager.userTB.id
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                self.provider.networkManager
                    .fetch(WorkspaceByCodeQuery(code: self.workspaceCode))
                    .compactMap(\.workspaces?.edges.first)
                    .compactMap(\.?.node?.fragments.onlyWorkspaceFragment)
                    .map { fragment -> Mutation in
                        
                        var workspace = Workspace(only: fragment)
                        
                        if let role = fragment.role {
                            if role == .awaitingToJoin {
                                workspace.myMemberState = .requestingToJoin
                            } else {
                                workspace.myMemberState = .member
                            }
                        } else {
                            workspace.myMemberState = .notMember
                        }
                        
                        return .setWorkspace(workspace)
                    },
                .just(.setLoading(false))
            ])
            
        case .request:
            guard let worksapce = self.currentState.workspace else { return .empty() }
            let currentStatus = worksapce.myMemberState
            guard currentStatus != .member else { return .empty() }
            
            let call: Observable<Mutation> = {
                switch currentStatus {
                case .notMember:
                    return self.provider.networkManager
                        .fetch(WorkspaceByCodeQuery(code: self.workspaceCode))
                        .compactMap(\.workspaces?.edges.first)
                        .compactMap(\.?.node?.fragments.onlyWorkspaceFragment)
                        .flatMapLatest { fragment -> Observable<Mutation> in
                            let isEmailRequired = (fragment.isRequiredUserEmailToJoin == true)
                            let isPhonenumberRequired = (fragment.isRequiredUserPhoneNumberToJoin == true)
                            if isEmailRequired || isPhonenumberRequired {
                                let requireAttributes = [
                                    (isEmailRequired ? "이메일": nil),
                                    (isPhonenumberRequired ? "전화번호": nil)
                                ].compactMap { $0 }
                                .joined(separator: ", ")
                                let message = "해당 워크스페이스는 \(requireAttributes) 인증이 필수입니다. 인증 후 다시 시도해 주세요."
                                return .concat([
                                    .just(.setError(nil)),
                                    .just(.setError(message))
                                ])
                            }
                            return self.provider.networkManager
                                .perform(RequestJoinWorkspaceMutation(id: worksapce.id))
                                .compactMap(\.requestToJoinWorkspace)
                                .map { .setResult($0) }
                        }.catch { error in
                            let message = TRSError.common(.networkNotConnect).description
                            return .just(.setError(message))
                        }
                case .requestingToJoin:
                    return self.provider.networkManager
                        .perform(CancelJoinWorkspaceMutation(id: worksapce.id))
                        .compactMap(\.cancelToJoinWorkspace)
                        .map { .setResult($0) }
                default:
                    return .empty()
                }
            }()
            return .concat([
                .just(.setResult(nil)),
                .just(.setLoading(true)),
                call,
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
            
        case let .setResult(result):
            state.result = result
            if result == true {
                state.errorMessage = nil
            }
            
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
