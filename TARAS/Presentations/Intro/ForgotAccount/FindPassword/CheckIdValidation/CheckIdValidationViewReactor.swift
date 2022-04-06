//
//  CheckIdValidationViewReactor.swift
//  TARAS
//
//  Created by 오현식 on 2022/04/05.
//

import ReactorKit
import RxSwift

class CheckIdValidationViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case checkValidation(id: String)
        case checkRegistration(id: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsAvailable(Bool)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
        case resetState
    }

    struct State {
        var isValid: Bool
        var isAvailable: Bool
        var isProcessing: Bool
        var errorMessage: String?
    }

    let provider: ManagerProviderType
    let id: String

    var initialState: State = .init(
        isValid: false,
        isAvailable: false,
        isProcessing: false,
        errorMessage: nil
    )

    init(provider: ManagerProviderType, id: String = "") {
        self.provider = provider
        self.id = id
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let id):
            let isValid = InputPolicy.id.matchRange(id)
            return .concat([
                .just(.updateError(nil)),
                .just(.updateIsValid(isValid))
            ])
                
        case .checkRegistration(let id):
            guard InputPolicy.id.matchFormat(id) else {
                return .just(.updateError(.common(.invalidInputFormat(.id))))
            }
            
            let mutation = ValidateUsernameMutation(id: id)
            return .concat([
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .compactMap { !($0.validateUsername ?? true) }
                    .flatMapLatest { isAvailable -> Observable<Mutation> in
                        if isAvailable {
                            return .concat([
                                .just(.updateIsAvailable(isAvailable)),
                                .just(.resetState)
                            ])
                        } else {
                            return .concat([
                                .just(.updateError(.account(.idNotExist))),
                                .just(.updateIsAvailable(isAvailable))
                            ])
                        }
                    }.catchAndReturn(.updateError(.common(.networkNotConnect))),
                
                .just(.updateIsProcessing(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
        case .updateIsAvailable(let isAvailable):
            state.isAvailable = isAvailable
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        case .resetState:
            state.isAvailable = false
        }
        return state
    }
}


// MARK: - Reactor For

extension CheckIdValidationViewReactor {
    
    func reactorForCertifyEmail(_ id: String) -> ForgotAccountCertifyEmailViewReactor {
        return ForgotAccountCertifyEmailViewReactor(provider: self.provider, id: id)
    }
}
