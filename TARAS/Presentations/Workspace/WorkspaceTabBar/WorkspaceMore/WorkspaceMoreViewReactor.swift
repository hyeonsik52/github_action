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


//import Foundation
//import ReactorKit
//
//class WorkspaceMoreViewReactor: Reactor {
//
//    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
//
//    enum Action {
//        case refresh
//        case requestQuitSWS
//    }
//
//    enum Mutation {
//        case loadedUserInfo(User?)
//        case loadedWorkspaceInfo(Workspace?)
//        case setLoading(Bool?)
//        case updateDidQuitSWS(Bool)
//        case updateAlertMessage(String)
//    }
//
//    struct State {
//        var userInfo: User?
//        var workspace: Workspace?
//        var isLoading: Bool?
//        var alertMessage: String
//        var didQuitSWS: Bool
//    }
//
//    var initialState: State {
//        return .init(
//            userInfo: nil,
//            workspace: nil,
//            isLoading: nil,
//            alertMessage: "",
//            didQuitSWS: false
//        )
//    }
//
//    let provider : ManagerProviderType
//    let workspaceId: String
//
//    init(provider: ManagerProviderType, workspaceId: String) {
//        self.provider = provider
//        self.workspaceId = workspaceId
//    }
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .refresh:
//            return .concat([
//                .just(.setLoading(true)),
//
//                self.provider.networkManager
//                    .fetch(MyUserInfoQuery())
//                    .compactMap(\.signedUser?.fragments.userFragment)
//                    .map{Mutation.loadedUserInfo(.init($0))},
//
//                self.provider.networkManager
//                    .fetch(WorkspaceByIdQuery(workspaceId: self.workspaceId))
//                    .compactMap(\.signedUser?.joinedWorkspaces?.edges.first)
//                    .compactMap(\.?.node?.fragments.workspaceFragment)
//                    .map{ Mutation.loadedWorkspaceInfo(.init($0)) },
//
//                .just(.setLoading(false))
//            ])
//
//        case .requestQuitSWS:
//            return self.provider.networkManager
//                .perform(LeaveWorkspaceMutation(workspaceId: self.workspaceId))
//                .map { $0.leaveWorkspace ?? false }
//                .flatMap { result -> Observable<Mutation> in
//                    if result == true {
//                        self.provider.userManager.userTB.update {
//                            $0.lastWorkspaceId = nil
//                        }
//                        return .just(.updateDidQuitSWS(true))
//                    } else {
//                        return .just(.updateAlertMessage("이미 탈퇴한 워크스페이스입니다."))
//                    }
//                }.catchAndReturn(.updateAlertMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)"))
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var state = state
//        switch mutation {
//        case let .loadedUserInfo(info):
//            state.userInfo = info
//
//        case let .loadedWorkspaceInfo(workspace):
//            state.workspace = workspace
//
//        case let .setLoading(isLoading):
//            state.isLoading = isLoading
//
//        case let .updateAlertMessage(alertMessage):
//            state.alertMessage = alertMessage
//
//        case let .updateDidQuitSWS(didQuitSWS):
//            state.didQuitSWS = didQuitSWS
//        }
//        return state
//    }
//
//    //워크스페이스 정보
//    func reactorForWorkspaceInfo() -> WorkspaceInfoViewReactor {
//        return WorkspaceInfoViewReactor(provider: self.provider, workspaceId: self.workspaceId)
//    }
//
//    //이름 변경
//    func reactorForNameUpdate() -> UpdateNameViewReactor {
//        return UpdateNameViewReactor(
//            provider: self.provider,
//            workspaceId: self.workspaceId,
//            placeholder: self.currentState.userInfo?.displayName ?? ""
//        )
//    }
//
//    //이메일 변경
//    func reactorForEmailUpdate() -> UpdateEmailViewReactor {
//        return UpdateEmailViewReactor(
//            provider: self.provider,
//            workspaceId: self.workspaceId,
//            placeholder: self.currentState.userInfo?.email ?? ""
//        )
//    }
//
//    //전화번호 변경
//    func reactorForPhoneNumberUpdate() -> UpdatePhoneNumberViewReactor {
//        let phoneNumber = self.currentState.userInfo?.phonenumber ?? ""
//        return UpdatePhoneNumberViewReactor(
//            provider: self.provider,
//            workspaceId: self.workspaceId,
//            placeholder: phoneNumber
//        )
//    }
//
//    //기본 정보 설정
//    func reactorForDefaultMyInfo() -> DefaultMyInfoViewReactor {
//        return DefaultMyInfoViewReactor(provider: self.provider)
//    }
//}
