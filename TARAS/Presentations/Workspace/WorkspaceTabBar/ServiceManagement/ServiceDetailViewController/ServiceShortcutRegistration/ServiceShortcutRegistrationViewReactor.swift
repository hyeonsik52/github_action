//
//  ServiceShortcutRegistrationViewReactor.swift
//  TARAS
//
//  Created by nexmond on 2022/02/15.
//

import ReactorKit

class ServiceShortcutRegistrationViewReactor: Reactor {
    
    enum Text {
        static let errorRequestFailed = "요청에 실패했습니다."
        static let errorRegistrationFailed = "간편 생성을 등록하지 못했습니다."
        static let errorNetworkConnection = "서버와의 통신이 원활하지 않습니다."
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action {
        case register(name: String, description: String?)
    }
    
    enum Mutation {
        case updateIsConfirmed(Bool?)
        case updateIsProcessing(Bool?)
        case updateErrorMessage(String?)
    }
    
    struct State {
        var isConfirmed: Bool?
        var isProcessing: Bool?
        var errorMessage: String?
    }
    
    let initialState: State = .init()
    
    let provider: ManagerProviderType
    let workspaceId: String
    let serviceId: String
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceId: String
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceId = serviceId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .register(let name, let description):
            let description = (description ?? "").isEmpty ? nil: description
            let input = CreateServiceTemplateFromServiceInput(
                description: description,
                name: name,
                serviceId: self.serviceId,
                userId: self.provider.userManager.userTB.ID,
                workspaceId: self.workspaceId
            )
            return .concat([
                .just(.updateErrorMessage(nil)),
                .just(.updateIsConfirmed(nil)),
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(CreateServiceTemplateMutation(input: input))
                    .map { $0.createServiceTemplateFromService?.id != nil }
                    .flatMapLatest { isSuccess -> Observable<Mutation> in
                        if isSuccess {
                            return .just(.updateIsConfirmed(true))
                        } else {
                            return .just(.updateErrorMessage(Text.errorRegistrationFailed))
                        }
                    }.catch(self.catchClosure),
                
                .just(.updateIsProcessing(false))
            ])
        }
    }
    
    var catchClosure: ((Error) throws -> Observable<Mutation>) {
        return { error in
            guard let multipleError = error as? MultipleError,
                  let errors = multipleError.graphQLErrors else {
                return .just(.updateErrorMessage(Text.errorNetworkConnection))
            }
            for error in errors {
                guard let message = error.message, !message.isEmpty else { continue }
                return .just(.updateErrorMessage(message))
            }
            return .just(.updateErrorMessage(Text.errorRequestFailed))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateIsConfirmed(let isConfirmed):
            state.isConfirmed = isConfirmed
        case .updateErrorMessage(let message):
            state.errorMessage = message
        }
        return state
    }
}
