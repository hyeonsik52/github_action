//
//  WorkspaceHomeReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/24.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

class WorkspaceHomeReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case loadMyInfo
        case loadWorkspaceInfo
        case judgeIsFromPush
    }
    
    enum Mutation {
        case loadedMyInfo(User?)
        case loadedWorkspaceInfo(Workspace?)
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case isProcessing(Bool?) //추가 로딩
        case updateIsFromPush(Bool)
    }
    
    struct State {
        var myUserInfo: User?
        var worspace: Workspace?
        var isLoading: Bool?
        var isProcessing: Bool?
        var isFromPush: Bool
    }
    
    var initialState: State {
        return State(
            myUserInfo: nil,
            worspace: nil,
            isLoading: nil,
            isProcessing: nil,
            isFromPush: false
        )
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    let pushInfo: NotificationInfo?
    
    init(provider: ManagerProviderType, workspaceId: String, pushInfo: NotificationInfo? = nil) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.pushInfo = pushInfo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .loadMyInfo:
            return self.provider.networkManager
                .fetch(MyUserInfoQuery())
                .compactMap(\.signedUser?.fragments.userFragment)
                .map{ Mutation.loadedMyInfo(.init($0)) }
            
        case .loadWorkspaceInfo:
            return self.provider.networkManager
                .fetch(WorkspaceByIdQuery(id: self.workspaceId))
                .compactMap(\.signedUser?.joinedWorkspaces?.edges.first)
                .compactMap(\.?.node?.fragments.workspaceFragment)
                .do { [weak self] workspace in
                    self?.provider.userManager.userTB.update {
                        $0.lastWorkspaceId ??= workspace.id
                    }
                }.map { .loadedWorkspaceInfo(.init($0)) }
            
        case .judgeIsFromPush:
            let isFromPush = (self.pushInfo != nil)
            return .just(.updateIsFromPush(isFromPush))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedMyInfo(info):
            state.isFromPush = false
            state.myUserInfo = info
            
        case let .loadedWorkspaceInfo(workspace):
            state.isFromPush = false
            state.worspace = workspace
            
        case .isLoading(let loading):
            state.isFromPush = false
            state.isLoading = loading
            
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
            
        case let .updateIsFromPush(isFromPush):
            state.isFromPush = isFromPush
        }
        return state
    }
    
    func reactorForCreateService() -> CreateServiceViewReactor {
        return CreateServiceViewReactor(provider: self.provider, workspaceId: self.workspaceId)
    }
}
