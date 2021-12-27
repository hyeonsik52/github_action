//
//  SignUpIdViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class SignUpIdViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Text {
        static let SUIVR_1 = "사용 가능한 아이디입니다."
    }
    
    enum Action: Equatable {
        case checkValidation(id: String)
        case checkDuplication(id: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsAvailable(Bool)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }

    struct State {
        var isValid: Bool
        var isAvailable: Bool
        var isProcessing: Bool
        var message: (message: String, color: UIColor)?
    }

    let provider: ManagerProviderType
    
    /// 회원가입 정보
    var accountInfo: Account

    var initialState: State = .init(
        isValid: false,
        isAvailable: false,
        isProcessing: false,
        message: nil
    )

    init(provider: ManagerProviderType) {
        self.provider = provider
        self.accountInfo = Account()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let id):
            let isValid = InputPolicy.id.matchRange(id)
            return .just(.updateIsValid(isValid))
        case .checkDuplication(let id):
            guard InputPolicy.id.matchFormat(id) else {
                return .just(.updateError(.common(.invalidInputFormat(.id))))
            }
            
            let mutation = ValidateUsernameMutation(id: id)
            return .concat([
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .map { [weak self] payload in
                        if payload.validateUsername == true {
                            self?.accountInfo.id = id
                            return .updateIsAvailable(true)
                        } else {
                            return .updateError(.account(.idExisted))
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
            state.isAvailable = false
            state.message = nil
        case .updateIsAvailable(let isAvailable):
            state.isAvailable = isAvailable
            state.message = (Text.SUIVR_1, .green00B300)
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            let message = error?.description
            state.message = (message == nil ? nil: (message!, .redEB4D39))
        }
        return state
    }
}


// MARK: - Reactor For

extension SignUpIdViewReactor {
    
    func reactorForPassword(_ id: String) -> SignUpPasswordViewReactor {
        self.accountInfo.id = id
        return SignUpPasswordViewReactor(provider: self.provider, accountInfo: self.accountInfo)
    }
}
