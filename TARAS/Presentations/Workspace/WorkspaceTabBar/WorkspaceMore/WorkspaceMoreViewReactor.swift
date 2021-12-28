//
//  WorkspaceMoreViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/25.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class WorkspaceMoreViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case reload
        case quit
    }
    
    enum Mutation {
        case reloadWorkspace(Workspace?)
        case updateIsQuit(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var workspace: Workspace?
        var isQuit: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let initialState: State = .init(
        workspace: nil,
        isQuit: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    let provider: ManagerProviderType
    let workspaceId: String
    
    init(provider: ManagerProviderType, workspaceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reload:
            return self.reload()
        case .quit:
            return self.quit()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadWorkspace(let workspace):
            state.workspace = workspace
        case .updateIsQuit(let isQuit):
            state.isQuit = isQuit
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    private func reload() -> Observable<Mutation> {
        return .concat([
            .just(.updateError(nil)),

            self.provider.networkManager
                .fetch(WorkspaceByIdQuery(id: self.workspaceId))
                .compactMap(\.signedUser?.joinedWorkspaces?.edges.first)
                .flatMapLatest { joinedWorkspace -> Observable<Mutation> in
                    if let fragment = joinedWorkspace?.node?.fragments.workspaceFragment {
                        return .just(.reloadWorkspace(.init(fragment)))
                    } else {
                        return .just(.updateError(.etc("탈퇴한 워크스페이스입니다.")))
                    }
                }.catchAndReturn(.updateError(.common(.networkNotConnect)))
        ])
    }
    
    private func quit() -> Observable<Mutation> {
        return .concat([
            .just(.updateError(nil)),
            .just(.updateIsProcessing(true)),
            
            self.provider.networkManager
                .perform(LeaveWorkspaceMutation(id: self.workspaceId))
                .map { $0.leaveWorkspace ?? false }
                .flatMap { result -> Observable<Mutation> in
                    if result == true {
                        self.provider.userManager.userTB.update {
                            $0.lastWorkspaceId = nil
                        }
                        return .just(.updateIsQuit(true))
                    } else {
                        return .just(.updateError(.etc("이미 탈퇴한 워크스페이스입니다.")))
                    }
                }.catchAndReturn(.updateError(.common(.networkNotConnect))),
            
                .just(.updateIsProcessing(false))
        ])
    }
    
    func reactorForSetting() -> DefaultMyInfoViewReactor {
        return DefaultMyInfoViewReactor(provider: self.provider)
    }
}
