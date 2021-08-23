//
//  Default_PWConfirmed_ViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/31.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class Default_PWConfirmed_ViewReactor: Reactor {

    enum Action {
        case setConfirmedPW(String)
        case setIsLoading(Bool)
        case didConfirmButtonTap
    }

    enum Mutation {
        case updateDidConfirmedPW(Bool)
        case updateErrorMessage(String?)
        case updateIsLoading(Bool)
    }

    struct State {
        var isLoading: Bool
        var errorMessage: String?
        var didConfirmedPW: Bool
    }

    let provider: ManagerProviderType
    
    let password: String
    
    var confirmedPW: String = ""
    
    let authCode: String

    let initialState: State

    init(provider: ManagerProviderType, password: String, authCode: String) {
        self.provider = provider
        self.password = password
        self.authCode = authCode
        
        self.initialState = .init(isLoading: false, errorMessage: nil, didConfirmedPW: false)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setConfirmedPW(confirmedPW):
            self.confirmedPW = confirmedPW
            return .empty()

        case let .setIsLoading(isLoading):
            return .just(.updateIsLoading(isLoading))

        case .didConfirmButtonTap:
            
            guard self.confirmedPW == self.password else {
                return .just(.updateErrorMessage("비밀번호가 일치하지않습니다."))
            }
            
            let input = ResetUserPasswordByAuthCodeInput(authCode: self.authCode, password: self.confirmedPW)
            
            return .concat([
                .just(.updateIsLoading(true)),
                
                self.provider.networkManager.perform(ResetUserPasswordByAuthCodeMutation(input: input))
                    .map { $0.resetUserPasswordByAuthCodeMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let payload = data.asResetUserPasswordPayload {
                            if payload.result == "1" {
                                return .just(.updateDidConfirmedPW(true))
                            }
                        }
                        if let errorCode = data.asResetUserPasswordError?.errorCode {
                            if errorCode == .invalidAuthCode {
                                return .just(.updateErrorMessage("잘못된 인증번호입니다. (현재 비밀번호를 다시 확인해주세요.)"))
                            }
                        }
                        return .just(.updateErrorMessage("비밀번호 변경에 실패했습니다. 고객 센터로 문의해주세요."))
                }.catchErrorJustReturn(.updateErrorMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)")),
                
                .just(.updateIsLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateErrorMessage(errorMessage):
            state.errorMessage = errorMessage

        case let .updateIsLoading(isLoading):
            state.isLoading = isLoading

        case let .updateDidConfirmedPW(didConfirmedPW):
            state.didConfirmedPW = didConfirmedPW
        }
        return state
    }
}
