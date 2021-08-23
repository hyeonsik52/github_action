//
//  FindAccountPasswordViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class FindAccountPasswordViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    /// 진입 유형
    enum EntryType {
        /// 아이디, 비밀번호 찾기를 통해
        case findAccount
        /// 전체 설정을 통해
        case setting
    }
    
    enum Text {
        static let SUPVR_1 = "비밀번호는 8~32자로 설정해 주세요."
    }

    enum Action: Equatable {
        case checkPasswordValidation(password: String, confirm: String)
        case checkConfirmValidation(password: String, confirm: String)
        case resetPassword(password: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsReset(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isReset: Bool?
        var isProcessing: Bool
        var errorMessage: String?
        var type: EntryType
    }
    
    let provider: ManagerProviderType
    
    /// 회원가입 정보
    var accountInfo: Account
    
    let initialState: State
    
    init(provider: ManagerProviderType, entryType: EntryType, accountInfo: Account = Account()) {
        self.provider = provider
        self.accountInfo = accountInfo
        self.initialState = .init(
            isValid: false,
            isReset: nil,
            isProcessing: false,
            errorMessage: nil,
            type: entryType
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkPasswordValidation(let password, let confirm):
            guard InputPolicy.password.matchRange(password),
                  password == confirm else {
                return .just(.updateIsValid(false))
            }
            return .just(.updateIsValid(true))
        case .checkConfirmValidation(let password, let confirm):
            guard !confirm.isEmpty else {
                return .just(.updateIsValid(false))
            }
            guard password == confirm else {
                return .concat([
                    .just(.updateIsValid(false)),
                    .just(.updateError(.account(.passwordNotMatch)))
                ])
            }
            return .just(.updateIsValid(true))
        case .resetPassword(let password):
            guard let authToken = self.accountInfo.authToken else {
                return .just(.updateError(.account(.authNumberNotMatch)))
            }
            switch self.initialState.type {
            case .findAccount:
                return self.resetPasswordByEmail(password, authToken: authToken)
            case .setting:
                return self.resetPasswordByAuth(password, authToken: authToken)
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
        case .updateIsReset(let isReset):
            state.isReset = isReset
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    private func resetPasswordByEmail(_ password: String, authToken: String) -> Observable<Mutation> {
        
        let input = ResetUserPasswordByEmailInput(
            email: self.accountInfo.email,
            emailToken: authToken,
            password: password
        )
        let mutation = ResetUserPasswordByEmailMutation(input: input)
        
        return .concat([
            .just(.updateIsReset(nil)),
            .just(.updateIsProcessing(true)),
            
            self.provider.networkManager.perform(mutation)
                .map { $0.resetUserPasswordByEmailMutation }
                .flatMapLatest { result -> Observable<Mutation> in
                    if let typeError = result.asTypeError?.fragments.typeErrorFragment {
                        return .just(.updateError(.common(.type(typeError))))
                    }else if let error = result.asResetUserPasswordError {
                        let error: TRSError? = {
                            switch error.findErrorCode {
                            case .invalidEmailToken:
                                return .account(.authNumberNotMatch)
                            default:
                                return .etc(error.findErrorCode.rawValue)
                            }
                        }()
                        return .just(.updateError(error))
                    }else if let payload = result.asResetUserPasswordPayload {
                        let success = payload.result.isTrue
                        return .just(.updateIsReset(success))
                    }
                    return .empty()
                }
                .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),
            
            .just(.updateIsProcessing(false))
        ])
    }
    
    private func resetPasswordByAuth(_ password: String, authToken: String) -> Observable<Mutation> {
        
        let input = ResetUserPasswordByAuthCodeInput(authCode: authToken, password: password)
        let mutation = ResetUserPasswordByAuthCodeMutation(input: input)
        
        return .concat([
            .just(.updateIsReset(nil)),
            .just(.updateIsProcessing(true)),
            
            self.provider.networkManager.perform(mutation)
                .map { $0.resetUserPasswordByAuthCodeMutation }
                .flatMapLatest { result -> Observable<Mutation> in
                    if let typeError = result.asTypeError?.fragments.typeErrorFragment {
                        return .just(.updateError(.common(.type(typeError))))
                    }else if let error = result.asResetUserPasswordError {
                        let error: TRSError? = {
                            switch error.authErrorCode {
                            case .invalidAuthCode:
                                return .account(.authNumberNotMatch)
                            default:
                                return .etc(error.authErrorCode.rawValue)
                            }
                        }()
                        return .just(.updateError(error))
                    }else if let payload = result.asResetUserPasswordPayload {
                        let success = payload.result.isTrue
                        return .just(.updateIsReset(success))
                    }
                    return .empty()
                }
                .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),
            
            .just(.updateIsProcessing(false))
        ])
    }
}
