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
        case refreshInfo
        case loadTemplates
    }
    
    enum Mutation {
        case loadedMyInfo(User?)
        case loadedWorkspaceInfo(Workspace?)
        case loadTemplates([ServiceTemplate])
        case isLoading(Bool)
    }
    
    struct State {
        var myUserInfo: User?
        var worspace: Workspace?
        var templates: [ServiceTemplate]
        var isLoading: Bool
    }
    
    var initialState: State {
        return State(
            myUserInfo: nil,
            worspace: nil,
            templates: [],
            isLoading: false
        )
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    
    init(provider: ManagerProviderType, workspaceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshInfo:
            return .concat([
                self.provider.networkManager
                    .fetch(MyUserInfoQuery())
                    .compactMap(\.signedUser?.fragments.userFragment)
                    .map{ Mutation.loadedMyInfo(.init($0)) },
                self.provider.networkManager
                    .fetch(WorkspaceByIdQuery(id: self.workspaceId))
                    .compactMap(\.signedUser?.joinedWorkspaces?.edges.first)
                    .compactMap(\.?.node?.fragments.workspaceFragment)
                    .do { [weak self] workspace in
                        self?.provider.userManager.userTB.update {
                            $0.lastWorkspaceId ??= workspace.id
                        }
                    }.map { .loadedWorkspaceInfo(.init($0)) }
            ])
        case .loadTemplates:
            return .concat([
                .just(.isLoading(true)),
                
                self.provider.networkManager
                    .fetch(ServiceTemplatesQuery(workspaceId: self.workspaceId))
                    .compactMap { $0.serviceTemplates?.edges.compactMap(\.?.node) }
                    .compactMap { $0.compactMap { $0.fragments.serviceTemplateFragment } }
                    .map { $0.map(ServiceTemplate.init) }
                    .map { .loadTemplates($0) },
                
                .just(.isLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedMyInfo(info):
            state.myUserInfo = info
        case let .loadedWorkspaceInfo(workspace):
            state.worspace = workspace
        case let .loadTemplates(templates):
            state.templates = templates
        case .isLoading(let loading):
            state.isLoading = loading
        }
        return state
    }
}

extension WorkspaceHomeReactor {
    
    func reactorForServiceCreation(with template: ServiceTemplate) -> ServiceCreationViewReactor {
        return .init(provider: self.provider, workspaceId: self.workspaceId, template: template)
    }
}
