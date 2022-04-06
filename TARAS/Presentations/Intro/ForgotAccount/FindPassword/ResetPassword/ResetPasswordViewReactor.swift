//
//  ResetPasswordViewReactor.swift
//  TARAS
//
//  Created by 오현식 on 2022/04/05.
//

import ReactorKit
import RxSwift

class ResetPasswordViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)

    enum Action: Equatable {
        case checkPasswordValidation(password: String, confirm: String)
        case updatePassword(password: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updatePassword(Bool)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isUpdate: Bool
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    let token: String
    let id: String
    
    let initialState: State = .init(
        isValid: false,
        isUpdate: false,
        isProcessing: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType, id: String, token: String) {
        self.provider = provider
        self.id = id
        self.token = token
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkPasswordValidation(let password, let confirm):
            guard !confirm.isEmpty, InputPolicy.password.matchRange(password) else {
                return .just(.updateIsValid(false))
            }
            if password != confirm {
                return .concat([
                    .just(.updateIsValid(false)),
                    .just(.updateError(.account(.passwordNotMatch)))
                ])
            } else {
                return .just(.updateIsValid(true))
            }
            
        case .updatePassword(let password):
            let input = ResetPasswordMutationInput(
                password: password,
                token: self.token,
                username: self.id
            )
            let mutation = ResetPasswordMutation(input: input)
            
            return .concat([
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .compactMap { $0.resetPassword }
                    .flatMapLatest { result -> Observable<Mutation> in
                        if result {
                            return .just(.updatePassword(result))
                        } else {
                            return .just(.updateError(.etc("업데이트 하지 못했습니다.")))
                        }
                    }
                    .catch { error in
                        let message = "\(error)"
                        
                        if message.contains("No user with username") {
                            return .just(.updateError(.etc("아이디와 일치하는 사용자가 없습니다.")))
                        } else if message.contains("Given password is not changed") {
                            return .just(.updateError(.etc("새로운 비밀번호를 입력해주세요.")))
                        } else if message.contains("Invalid authentication token") {
                            return .just(.updateError(.etc("이메일 인증 토큰이 유효하지 않습니다. 이메일 인증을 다시 시도해주세요.")))
                        } else {
                            return .just(.updateError(.common(.networkNotConnect)))
                        }
                    },
                
                .just(.updateIsProcessing(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
        case .updatePassword(let isUpdate):
            state.isUpdate = isUpdate
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
}

extension ResetPasswordViewReactor {
    
    func reactorForCompleteResetPassword(_ password: String) -> CompleteResetPasswordViewReactor {
        return CompleteResetPasswordViewReactor(provider: self.provider, id: self.id, password: password)
    }
}
