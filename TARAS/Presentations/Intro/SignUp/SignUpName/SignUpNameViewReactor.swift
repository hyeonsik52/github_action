//
//  SignUpNameViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class SignUpNameViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)

    enum Action: Equatable {
        case checkValidation(name: String)
        case signUp(name: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsSignUp(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isSignUp: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    /// 회원가입 정보
    var accountInfo: Account
    
    let initialState: State = .init(
        isValid: false,
        isSignUp: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType, accountInfo: Account) {
        self.provider = provider
        self.accountInfo = accountInfo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let name):
            let isValid = InputPolicy.name.matchRange(name)
            return .just(.updateIsValid(isValid))
        case .signUp(let name):
            return self.signUp(name)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
        case .updateIsSignUp(let isSignUp):
            state.isSignUp = isSignUp
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    private func signUp(_ name: String) -> Observable<Mutation> {
        guard let clientInfo = self.provider.userManager.userTB.clientInfo else {
            return .empty()
        }
        
//        let nationalizedPhoneNumber = phoneNumber.nationalizePhoneNumber
        
//        let input = SignupInput(
//            clientInfo: clientInfo,
//            clientType: "ios",
//            email: self.accountInfo.email,
//            name: self.accountInfo.name,
//            password: self.accountInfo.password,
//            phoneNumber: phoneNumber,
//            userId: self.accountInfo.id
//        )
//
//        return self.signUp(input: input)
        
        let input = CreateUserMutationInput(
            password: self.accountInfo.password,
            username: self.accountInfo.id,
            displayName: name
        )
        
        return self.signUp(input: input)
    }
        
    private func signUp(input: CreateUserMutationInput) -> Observable<Mutation> {

        let mutation = SignUpMutation(input: input)

        let prevIsValid = self.currentState.isValid
        return .concat([
            .just(.updateIsValid(false)),
            .just(.updateIsProcessing(true)),

            self.provider.networkManager.perform(mutation)
                .map { $0.createUser }
                .flatMap { result -> Observable<Mutation> in
                    if let errors = result?.errors {
                        let etcErrors = TRSError.list(errors.compactMap { $0 }.map { TRSError.etc("[\($0.field)]: \($0.messages)") })
                        return .concat([
                            .just(.updateIsValid(prevIsValid)),
                            .just(.updateError(etcErrors))
                        ])
                    } else {
                        return .just(.updateIsSignUp(true))
                    }
                }
                .catchAndReturn(.updateError(.common(.networkNotConnect))),

            .just(.updateIsProcessing(false))
        ])
    }
}
