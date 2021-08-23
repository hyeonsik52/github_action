//
//  Default_PW_ViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/31.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit

class Default_PW_ViewReactor: Reactor {
    
    enum Action {
        case setPW(String)
        case requestAuthCode(password: String)
    }

    enum Mutation {
        case updateIsLoading(Bool)
        case updateErrorMessage(String?)
        case updateAuthCode(String)
    }

    struct State {
        var isLoading: Bool
        var errorMessage: String?
        var authCode: String?
    }

    let provider: ManagerProviderType

    var password: String = ""

    let initialState: State

    init(provider: ManagerProviderType) {
        self.provider = provider
        
        self.initialState = .init(isLoading: false, errorMessage: nil, authCode: nil)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPW(password):
            self.password = password
            return .empty()
            
        case let .requestAuthCode(password):
            let authCodeInput = CreateAuthCodeInput(codeType: .updateUserInfo, password: password)
            
            return .concat([
                .just(.updateIsLoading(true)),
                
                self.provider.networkManager.perform(CreateAuthCodeMutation(input: authCodeInput))
                    .map { $0.createAuthCodeMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let payload = data.asCreateAuthCodePayload {
                            return .just(.updateAuthCode(payload.authCode))
                        }
                        if let errorCode = data.asCreateAuthCodeError?.errorCode {
                            if errorCode == .invalidPassword {
                                return .just(.updateErrorMessage("비밀번호가 정확하지 않습니다."))
                            }
                        }
                        return .just(.updateErrorMessage("알 수 없는 오류가 발생했습니다. 잠시 후에 다시 시도해 주세요."))
                }.catchErrorJustReturn(.updateErrorMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)")),
                
                .just(.updateIsLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateIsLoading(isLoading):
            state.isLoading = isLoading

        case let .updateErrorMessage(errorMessage):
            state.errorMessage = errorMessage
            
        case let .updateAuthCode(authCode):
            state.authCode = authCode
        }
        return state
    }
    
    func reactorForResetPW(_ authCode: String) -> Default_PWReset_ViewReactor {
        return Default_PWReset_ViewReactor(provider: self.provider, authCode: authCode)
    }
}
