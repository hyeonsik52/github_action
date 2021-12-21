//
//  ResetPasswordViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class ResetPasswordViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)

    enum Action: Equatable {
        case checkValidation(password: String)
        case requestAuth(password: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsAuthing(String?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isAuthComplete: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    /// 회원가입 정보
    var accountInfo: Account
    
    let initialState: State = .init(
        isValid: false,
        isAuthComplete: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType) {
        self.provider = provider
        self.accountInfo = Account()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let password):
            let isValid = InputPolicy.password.matchRange(password)
            return .just(.updateIsValid(isValid))
        case .requestAuth(let password):
            
//            let input = CreateAuthCodeInput(codeType: .updateUserInfo, password: password)
//            let mutation = CreateAuthCodeMutation(input: input)
//
//            return .concat([
//                .just(.updateIsProcessing(true)),
//
//                self.provider.networkManager.perform(mutation)
//                    .map { $0.createAuthCodeMutation }
//                    .flatMapLatest { result -> Observable<Mutation> in
//                        if let typeError = result.asTypeError?.fragments.typeErrorFragment {
//                            return .just(.updateError(.common(.type(typeError))))
//                        }else if let error = result.asCreateAuthCodeError {
//                            let error: TRSError? = {
//                                switch error.authErrorCode {
//                                case .invalidPassword:
//                                    return .account(.invalidPassword)
//                                case .invalidUserId:
//                                    return .account(.idNotExist)
//                                default:
//                                    return .etc(error.authErrorCode.rawValue)
//                                }
//                            }()
//                            return .just(.updateError(error))
//                        }else if let payload = result.asCreateAuthCodePayload {
//                            return .concat([
//                                .just(.updateIsAuthing(payload.authCode)),
//                                .just(.updateIsAuthing(nil))
//                            ])
//                        }
//                        return .empty()
//                    }
//                    .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),
//
//                .just(.updateIsProcessing(false))
//            ])
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
            state.isAuthComplete = nil
        case .updateIsAuthing(let isAuthing):
            //temp
//            self.accountInfo.authToken = isAuthing
            state.isAuthComplete = (isAuthing != nil)
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    func reactorForPassword() -> FindAccountPasswordViewReactor {
        return FindAccountPasswordViewReactor(
            provider: self.provider,
            entryType: .setting,
            accountInfo: self.accountInfo
        )
    }
}
