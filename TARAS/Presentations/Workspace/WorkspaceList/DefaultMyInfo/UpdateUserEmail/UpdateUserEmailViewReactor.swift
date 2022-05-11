//
//  UpdateUserEmailViewReactor.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/29.
//

import ReactorKit
import RxSwift

class UpdateUserEmailViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    var requestId: String?
    
    enum Action: Equatable {
        case checkValidation(email: String)
        case checkEnable(authNumber: String)
        case sendAuthNumber(email: String)
        case checkAuthNumber(authNumber: String)
    }
    
    enum Mutation {
        case updateIsvalid(Bool)
        case updateEnable(Bool)
        case calculateRemainExpires(Date?)
        case updateUserEmail(Bool)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isEmailValid: Bool
        var isEmailEdited: Bool
        var isAuthNumberValid: Bool
        var authNumberExpires: Date?
        var isUpdateUserEmail: Bool
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    var initialState: State = .init(
        isEmailValid: false,
        isEmailEdited: false,
        isAuthNumberValid: false,
        authNumberExpires: nil,
        isUpdateUserEmail: false,
        isProcessing: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let email):
            return self.checkValidation(email: email)
        case .checkEnable(let authNumber):
            return self.checkEnable(authNumber: authNumber)
        case .sendAuthNumber(let email):
            return self.sendAuthNumber(email: email)
        case .checkAuthNumber(let authNumber):
            return self.checkAuthNumber(authNumber: authNumber)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsvalid(let isEmailValid):
            state.isEmailValid = isEmailValid
            state.isEmailEdited = true
        case .updateEnable(let isAuthNumberValid):
            state.isAuthNumberValid = isAuthNumberValid
        case .calculateRemainExpires(let authNumberExpires):
            state.isEmailEdited = false
            state.authNumberExpires = authNumberExpires
        case .updateUserEmail(let isUpdateUserEmail):
            state.isUpdateUserEmail = isUpdateUserEmail
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    private func checkValidation(email: String) -> Observable<Mutation> {
        let isMatch = InputPolicy.email.match(email)
        let isEmpty = email.isEmpty
        let error: TRSError? = isEmpty || isMatch ? nil : .common(.invalidInputFormat(.email))
        
        return .concat([
            .just(.updateError(error)),
            .just(.updateIsvalid(isMatch))
        ])
    }
    
    private func checkEnable(authNumber: String) -> Observable<Mutation> {
        let isMatch = InputPolicy.authNumber.match(authNumber)
        
        return .concat([
            .just(.updateError(nil)),
            .just(.updateEnable(isMatch))
        ])
    }
    
    private func sendAuthNumber(email: String) -> Observable<Mutation> {
        let input = RequestVerificationNumberMutationInput(
            data: email,
            methodType: .email,
            purpose: .updateEmailAddress
        )
        let mutation = RequestAuthMutation(input: input)
        
        return .concat([
            .just(.calculateRemainExpires(nil)),
            .just(.updateIsProcessing(true)),
            
            self.provider.networkManager.perform(mutation)
                .flatMapLatest { [weak self] result -> Observable<Mutation> in
                    guard let result = result.requestVerificationNumber else {
                        return .just(.updateError(.etc("인증번호 전송에 실패했습니다.")))
                    }
                    
                    self?.requestId = result.id
                    let convertExpiresSeconds = result.expires.timeIntervalSince(result.createdAt)
                    let currentDate = Date()
                    let expires = currentDate.addingTimeInterval(convertExpiresSeconds)

                    return .concat([
                        .just(.updateError(nil)),
                        .just(.calculateRemainExpires(expires))
                    ])
                }
                .catch { .just(.updateError(.certify(.sendAuthNumber($0.localizedDescription)))) },
            
            .just(.updateIsProcessing(false))
        ])
    }
    
    private func checkAuthNumber(authNumber: String) -> Observable<Mutation> {
        let input = CheckVerificationNumberMutationInput(
            requestId: self.requestId,
            verificationNumber: authNumber
        )
        let mutation = CheckAuthMutation(input: input)
        
        return .concat([
            .just(.updateIsProcessing(true)),
            .just(.updateError(nil)),
            
            self.provider.networkManager.perform(mutation)
                .compactMap { $0.checkVerificationNumber }
                .flatMapLatest { result -> Observable<Mutation> in
                    let mutation = UpdateUserEmailMutation(token: result.id)
                    return self.provider.networkManager.perform(mutation)
                        .map { .updateUserEmail($0.updateUserEmail ?? false) }
                }
                .catch { .just(.updateError(.certify(.checkAuthNumber($0.localizedDescription)))) },
            
                .just(.updateIsProcessing(false))
        ])
    }
}

