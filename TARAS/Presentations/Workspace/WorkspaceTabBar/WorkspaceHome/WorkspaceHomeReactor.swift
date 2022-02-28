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
    
    enum Text {
        static let errorRequestFailed = "요청에 실패했습니다."
        static let errorCreateServiceFailed = "서비스를 생성하지 못했습니다."
        static let errorShortcutDeletionFailed = "간편 생성을 삭제하지 못했습니다."
        static let errorNetworkConnection = "서버와의 통신이 원활하지 않습니다."
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refreshInfo
        case loadTemplates
        case createServiceByShortcut(id: String)
        case deleteShortcut(id: String)
    }
    
    enum Mutation {
        case loadedMyInfo(User?)
        case loadedWorkspaceInfo(Workspace?)
        case loadTemplates([ServiceTemplate])
        case isLoading(Bool)
        case isProcessing(Bool?)
        case updateError(String?)
        case isShortcutDeleted(Bool?)
        case isShortcutCreated(Bool?)
    }
    
    struct State {
        var myUserInfo: User?
        var worspace: Workspace?
        var templates: [ServiceTemplate]
        var isLoading: Bool
        var isProcessing: Bool?
        var errorMessage: String?
        var isShortcutDeleted: Bool?
        var isShortcutCreated: Bool?
    }
    
    var initialState: State = .init(
        myUserInfo: nil,
        worspace: nil,
        templates: [],
        isLoading: false,
        isProcessing: nil,
        errorMessage: nil,
        isShortcutDeleted: nil,
        isShortcutCreated: nil
    )
    
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
        case .createServiceByShortcut(let templateId):
            let json = try! GenericScalar(jsonValue: ["arguments": [:]])
            let input = CreateServiceWithServiceTemplateInput(
                input: json,
                serviceTemplateId: templateId
            )
            return .concat([
                .just(.isShortcutCreated(nil)),
                .just(.updateError(nil)),
                .just(.isProcessing(true)),
                
                self.provider.networkManager.perform(CreateServiceMutation(input: input))
                    .map { $0.createServiceWithServiceTemplate?.fragments.serviceFragment }
                    .map { fragment -> Mutation in
                        if fragment != nil {
                            return .isShortcutCreated(true)
                        } else {
                            return .updateError(Text.errorCreateServiceFailed)
                        }
                    }.catch(self.catchClosure),
                
                .just(.isProcessing(false))
            ])
        case .deleteShortcut(let templateId):
            return .concat([
                .just(.isShortcutDeleted(nil)),
                .just(.updateError(nil)),
                .just(.isProcessing(true)),
                
                self.provider.networkManager.perform(DeleteServiceTemplateMutation(id: templateId))
                    .map { payload -> Mutation in
                        if payload.deleteServiceTemplate == true {
                            return .isShortcutDeleted(true)
                        } else {
                            return .updateError(Text.errorShortcutDeletionFailed)
                        }
                    }.catch(self.catchClosure),
                
                .just(.isProcessing(false))
            ])
        }
    }
    
    var catchClosure: ((Error) throws -> Observable<Mutation>) {
        return { error in
            guard let multipleError = error as? MultipleError,
                  let errors = multipleError.graphQLErrors else {
                return .just(.updateError(Text.errorNetworkConnection))
            }
            for error in errors {
                guard let message = error.message, !message.isEmpty else { continue }
                return .just(.updateError(message))
            }
            return .just(.updateError(Text.errorRequestFailed))
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
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let message):
            state.errorMessage = message
        case .isShortcutDeleted(let succeeded):
            state.isShortcutDeleted = succeeded
        case .isShortcutCreated(let succeeded):
            state.isShortcutCreated = succeeded
        }
        return state
    }
}

extension WorkspaceHomeReactor {
    
    func reactorForServiceCreation(with template: ServiceTemplate) -> ServiceCreationViewReactor {
        return .init(provider: self.provider, workspaceId: self.workspaceId, process: .init(template: template))
    }
}
