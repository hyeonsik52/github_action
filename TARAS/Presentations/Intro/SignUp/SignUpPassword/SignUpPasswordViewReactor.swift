//
//  SignUpPasswordViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class SignUpPasswordViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Text {
        static let SUPVR_1 = "비밀번호는 8~32자로 설정해 주세요."
    }

    enum Action: Equatable {
        case checkPasswordValidation(password: String, confirm: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    /// 회원가입 정보
    var accountInfo: Account
    
    let initialState: State = .init(
        isValid: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType, accountInfo: Account) {
        self.provider = provider
        self.accountInfo = accountInfo
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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    func reactorForName(_ password: String) -> SignUpNameViewReactor {
        self.accountInfo.password = password
        return SignUpNameViewReactor(provider: self.provider, accountInfo: self.accountInfo)
    }
}
