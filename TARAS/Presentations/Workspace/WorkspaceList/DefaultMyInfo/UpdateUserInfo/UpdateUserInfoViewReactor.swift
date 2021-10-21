//
//  UpdateUserInfoViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/21.
//

import ReactorKit

class UpdateUserInfoViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case checkValidation(text: String)
        case update(text: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsUpdated(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isUpdated: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let initialState: State = .init(
        isValid: false,
        isUpdated: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    let provider: ManagerProviderType
    let inputType: AccountInputType
    let prevValue: String?
    
    init(provider: ManagerProviderType, inputType: AccountInputType, prevValue: String? = nil) {
        self.provider = provider
        self.inputType = inputType
        self.prevValue = prevValue
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let text):
            return self.checkValidation(text)
        case .update(let text):
            return self.update(text)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
        case .updateIsUpdated(let isUpdated):
            state.isUpdated = isUpdated
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    private func checkValidation(_ text: String) -> Observable<Mutation> {
        switch self.inputType {
        case .name:
            let isValid = self.inputType.policy.matchRange(text)
            return .just(.updateIsValid(isValid))
        case .email:
            guard !text.isEmpty else {
                return .just(.updateIsValid(false))
            }
            guard self.inputType.policy.matchFormat(text) else {
                return .concat([
                    .just(.updateIsValid(false)),
                    .just(.updateError(.common(.invalidInputFormat(.email))))
                ])
            }
            return .just(.updateIsValid(true))
        case .phoneNumber:
            let isValid = (text.count == 0 || self.inputType.policy.matchRange(text))
            return .just(.updateIsValid(isValid))
        default:
            return .empty()
        }
    }
    
    private func update(_ text: String) -> Observable<Mutation> {
        
//        let input: UpdateUserMutationInput = {
//            switch self.inputType {
//            case .name:
//                return .init(name: text)
//            case .email:
//                return .init(email: text)
//            case .phoneNumber:
//                return .init(phoneNumber: text)
//            default:
//                return .init()
//            }
//        }()
//
//        UpdateUserInfoMutation(input: <#T##UpdateUserMutationInput#>)
//
//        let mutation = UpdateUserInfoMutation(input: input)
//
//        if self.inputType == .email,
//           !self.inputType.policy.matchFormat(text) {
//            return .concat([
//                .just(.updateError(nil)),
//                .just(.updateError(.common(.invalidInputFormat(self.inputType))))
//            ])
//        }
//
//        return .concat([
//            .just(.updateIsUpdated(nil)),
//            .just(.updateIsProcessing(true)),
//
//            self.provider.networkManager.perform(mutation)
//                .map { $0.updateUserInfoMutation }
//                .flatMapLatest { result -> Observable<Mutation> in
//                    if let typeError = result.asTypeError?.fragments.typeErrorFragment {
//                        return .just(.updateError(.common(.type(typeError))))
//                    }else if let error = result.asUpdateUserInfoError {
//                        let error: TRSError? = {
//                            switch error.userErrorCode {
//                            default:
//                                return .etc(error.userErrorCode.rawValue)
//                            }
//                        }()
//                        return .just(.updateError(error))
//                    }else if let payload = result.asUser?.fragments.userFragment {
//                        self.provider.userManager.updateUserInfo(payload)
//                        return .just(.updateIsUpdated(true))
//                    }
//                    return .empty()
//                }
//                .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),
//
//            .just(.updateIsProcessing(false))
//        ])
        return .empty()
    }
}
