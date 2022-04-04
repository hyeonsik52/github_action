//
//  ForgotAccountCertifyEmailViewReactor.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/31.
//

import ReactorKit
import RxSwift

class ForgotAccountCertifyEmailViewReactor: Reactor {
    
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
        case calculateRemainExpires(Int)
        case findUsername(String)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isEnable: Bool
        var authNumberExpires: Int
        var findUsername: String
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    var initialState: State = .init(
        isValid: false,
        isEnable: false,
        authNumberExpires: 0,
        findUsername: "",
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
        case .updateIsvalid(let isValid):
            state.isValid = isValid
        case .updateEnable(let isEnable):
            state.isEnable = isEnable
        case .calculateRemainExpires(let authNumberExpires):
            state.authNumberExpires = authNumberExpires
        case .findUsername(let findUsername):
            state.findUsername = findUsername
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
            purpose: .findUser
        )
        let mutation = RequestAuthMutation(input: input)
        
        return .concat([
            .just(.calculateRemainExpires(0)),
            .just(.updateIsProcessing(true)),
            
            self.provider.networkManager.perform(mutation)
                .flatMapLatest { [weak self] result -> Observable<Mutation> in
                    guard let result = result.requestVerificationNumber else {
                        return .just(.updateError(.account(.authNumberSendFailed)))
                    }
                    
                    self?.requestId = result.id
                    let authNumberExpires = result.expires
                    let convertExpiresSeconds = self?.convertExpiresSeconds(
                        expires: authNumberExpires
                    ) ?? 0

                    return .concat([
                        .just(.updateError(nil)),
                        .just(.calculateRemainExpires(convertExpiresSeconds))
                    ])
                }
                .catch { error in
                    let message = "\(error)"
                    
                    if message.contains("does not exist") {
                        return .just(.updateError(.account(.unregisteredEmail)))
                    } else if message.contains("유효하지 않은 이메일 입니다.") {
                        return .just(.updateError(.etc("유효하지 않은 이메일 입니다.")))
                    } else {
                        return .just(.updateError(.common(.networkNotConnect)))
                    }
                },
            
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
                    return self.provider.networkManager.fetch(FindUserQuery(token: result.id))
                        .compactMap { $0.findUser }
                        .map { .findUsername($0.username) }
                }
                .catch { error in
                    let message = "\(error)"
                    
                    if message.contains("Invalid verification number") {
                        return .just(.updateError(.account(.authNumberNotMatch)))
                    } else {
                        return .just(.updateError(.common(.networkNotConnect)))
                    }
                },
            
                .just(.updateIsProcessing(false))
        ])
    }
    
    func convertExpiresSeconds(expires: DateTime) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = dateFormatter.date(from: String(expires.ISO8601Format))
            else { return 0 }
        
        let remainExpires = Int(date.timeIntervalSinceNow)
        
        return remainExpires > 1800 ? 1800 : remainExpires
    }
}


extension ForgotAccountCertifyEmailViewReactor {

    func reactorForCompleteFindId(_ id: String) -> CompleteFindIdViewReactor {
        return CompleteFindIdViewReactor(provider: self.provider, id: id)
    }
}

