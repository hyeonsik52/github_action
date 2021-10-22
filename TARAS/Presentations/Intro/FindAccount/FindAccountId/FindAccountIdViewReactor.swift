//
//  FindAccountIdViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class FindAccountIdViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)

    enum Action: Equatable {
        case checkValidation(id: String)
        case checkRegister(id: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsRegister(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isRegister: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let initialState: State = .init(
        isValid: false,
        isRegister: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    let provider: ManagerProviderType
    
    /// 계정 찾기 정보
    var accountInfo: Account
    
    init(provider: ManagerProviderType) {
        self.provider = provider
        self.accountInfo = Account()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let id):
            guard InputPolicy.id.matchRange(id) else {
                return .just(.updateIsValid(false))
            }
            guard InputPolicy.id.matchFormat(id) else {
                return .concat([
                    .just(.updateIsValid(false)),
                    .just(.updateError(.common(.invalidInputFormat(.id))))
                ])
            }
            return .just(.updateIsValid(true))
        case .checkRegister(let id):
            
//            let mutation = UserIdDuplicatedCheckMutation(input: .init(userId: id))
//
//            return .concat([
//                .just(.updateIsRegister(nil)),
//                .just(.updateIsProcessing(true)),
//
//                self.provider.networkManager.perform(mutation)
//                    .flatMap { payload -> Observable<Mutation> in
//                        let isDuplicated = !payload.userIdDuplicateCheckMutation.result.isTrue
//                        if isDuplicated {
//                            return .just(.updateIsRegister(true))
//                        }else{
//                            return .just(.updateError(.account(.idNotExist)))
//                        }
//                    }.catchErrorJustReturn(.updateError(.common(.networkNotConnect))),
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
        case .updateIsRegister(let isRegister):
            state.isRegister = isRegister
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    func reactorForEmail(_ id: String) -> FindAccountEmailViewReactor {
        self.accountInfo.id = id
        return FindAccountEmailViewReactor(provider: self.provider, accountInfo: self.accountInfo, type: .password)
    }
}
