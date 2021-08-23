//
//  FindAccountEmailViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class FindAccountEmailViewReactor: Reactor {
    
    enum FindType {
        case id, password
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case checkEmailValidation(email: String)
        case requestAuthNumber(email: String)
        case checkAuthCodeValidation(authCode: String)
        case checkAuthNumber(email: String, authCode: String)
        case tickTime
        case findId(email: String)
        case resetStates
    }
    
    enum Mutation {
        case updateIsValidEmail(Bool)
        case updateRequested(Bool?)
        case updateIsFirst(Bool)
        case updateRemainTime(Int?)
        case updateIsAvailable(Bool)
        case updateIsAuthComplete(String?)
        case updateFindIds([String]?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
        case stateReset
    }

    struct State {
        var isValidEmail: Bool
        var isRequested: Bool?
        var isFirst: Bool
        var remainTime: Int?
        var isAvailable: Bool
        var isAuthComplete: Bool?
        var findIds: [String]?
        var isProcessing: Bool
        var errorMessage: String?
        var type: FindType
    }

    let provider: ManagerProviderType
    
    /// 계정 찾기 정보
    var accountInfo: Account
    
    var expireDate: Date?
    var isFirst = true
    
    var initialState: State
    
    init(provider: ManagerProviderType, accountInfo: Account = Account(), type: FindType) {
        self.provider = provider
        self.accountInfo = accountInfo
        self.initialState = .init(
            isValidEmail: false,
            isRequested: nil,
            isFirst: true,
            remainTime: nil,
            isAvailable: false,
            isAuthComplete: nil,
            findIds: nil,
            isProcessing: false,
            errorMessage: nil,
            type: type
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkEmailValidation(let email):
            guard InputPolicy.email.matchFormat(email) else {
                return .just(.updateIsValidEmail(false))
            }
            return .just(.updateIsValidEmail(true))
        case .checkAuthCodeValidation(let authCode):
            guard InputPolicy.authNumber.matchRange(authCode) else {
                return .just(.updateIsAvailable(false))
            }
            return .just(.updateIsAvailable(true))
        case .requestAuthNumber(let email):
            
            guard InputPolicy.email.matchFormat(email) else {
                return .just(.updateError(.common(.invalidInputFormat(.email))))
            }
            
            let input = CreateEmailAuthCodeInput(
                checkExist: "true",
                email: email,
                userId: self.accountInfo.id
            )
            let mutation = CreateEmailAuthCodeMutation(input: input)

            return .concat([
                .just(.updateRequested(nil)),
                .just(.updateIsAvailable(false)),
                .just(.updateError(nil)),
                .just(.updateIsProcessing(true)),

                self.provider.networkManager.perform(mutation)
                    .map { $0.createEmailAuthCodeMutation }
                    .flatMap { result -> Observable<Mutation> in
                        if let typeError = result.asTypeError?.fragments.typeErrorFragment {
                            return .concat([
                                .just(.updateError(.common(.type(typeError)))),
                                .just(.updateIsFirst(false))
                            ])
                        }else if let _ = result.asCreateEmailAuthCodeError {
                            let error: TRSError = {
                                switch self.initialState.type {
                                case .id:
                                    return .account(.unregisteredEmail)
                                case .password:
                                    return .account(.idEmailNotMatch)
                                }
                            }()
                            return .concat([
                                .just(.updateError(error)),
                                .just(.updateIsFirst(false))
                            ])
                        }else if let payload = result.asCreateEmailAuthCodePayload {
                            let calendar = Calendar.current
                            let expireDate = calendar.date(byAdding: .second, value: payload.expiresIn, to: Date())
                            self.expireDate = expireDate
                            let now = Date()
                            let guaranteed = expireDate ?? now
                            let interval = Int(guaranteed.timeIntervalSince(now))
                            return .concat([
                                .just(.updateRemainTime(interval)),
                                .just(.updateRequested(true)),
                                .just(.updateIsFirst(false))
                            ])
                        }
                        return .empty()
                    }
                    .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),

                .just(.updateIsProcessing(false))
            ])
            
        case .checkAuthNumber(let email, let authCode):
            
            let input = CheckEmailAuthCodeInput(authCode: authCode, email: email)
            let mutation = CheckEmailAuthCodeMutation(input: input)
            
            return .concat([
                .just(.updateIsProcessing(true)),

                self.provider.networkManager.perform(mutation)
                    .map { $0.checkEmailAuthCodeMutation }
                    .flatMap { result -> Observable<Mutation> in
                        if let typeError = result.asTypeError?.fragments.typeErrorFragment {
                            return .just(.updateError(.common(.type(typeError))))
                        }else if let error = result.asCheckEmailAuthCodeError {
                            let error: TRSError? = {
                                switch error.authErrorCode {
                                case .invalidEmailAuthCode:
                                    return .account(.authNumberNotMatch)
                                default:
                                    return .etc(error.authErrorCode.rawValue)
                                }
                            }()
                            return .just(.updateError(error))
                        }else if let payload = result.asCheckEmailAuthCodePayload {
                            return .concat([
                                .just(.updateIsAuthComplete(payload.emailToken)),
                                .just(.updateIsAuthComplete(nil))
                            ])
                        }
                        return .empty()
                    }
                    .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),

                .just(.updateIsProcessing(false))
            ])
            
        case .tickTime:
            guard let expireDate = self.expireDate else {
                return .empty()
            }
            let interval = Int(expireDate.timeIntervalSince(Date()))
            guard interval > 0 else {
                self.expireDate = nil
                return .just(.updateRemainTime(0))
            }
            return .just(.updateRemainTime(interval))
            
        case .findId(let email):
            guard let authToken = self.accountInfo.authToken else {
                return .just(.updateError(.account(.authNumberNotMatch)))
            }
            
            let input = FindUserIdByEmailInput(email: email, emailToken: authToken)
            let mutation = FindUserIdListByEmailMutation(input: input)
            
            return .concat([
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .map { $0.findUserIdListByEmailMutation }
                    .flatMap { result -> Observable<Mutation> in
                        if let typeError = result.asTypeError?.fragments.typeErrorFragment {
                            return .just(.updateError(.common(.type(typeError))))
                        }else if let error = result.asFindUserIdError {
                            let error: TRSError? = {
                                switch error.findErrorCode {
                                case .invalidEmail:
                                    return .account(.unregisteredEmail)
                                case .invalidEmailToken:
                                    return .account(.authNumberNotMatch)
                                default:
                                    return .etc(error.findErrorCode.rawValue)
                                }
                            }()
                            return .just(.updateError(error))
                        }else if let payload = result.asFindUserIdListPayload {
                            let idList = payload.userIdList.compactMap { $0 }
                            return .just(.updateFindIds(idList))
                        }
                        return .empty()
                    }
                    .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),
                
                .just(.updateIsProcessing(false))
            ])
        case .resetStates:
            return .just(.stateReset)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValidEmail(let isValid):
            state.isValidEmail = isValid
            state.errorMessage = nil
            state.isRequested = nil
            state.isAvailable = false
        case .updateRequested(let isRequested):
            state.isRequested = isRequested
        case .updateIsFirst(let isFirst):
            guard self.isFirst == false else {
                self.isFirst = false
                break
            }
            state.isFirst = isFirst
        case .updateRemainTime(let remainTime):
            state.remainTime = remainTime
        case .updateIsAvailable(let isAvailable):
            state.isAvailable = isAvailable
            state.errorMessage = nil
        case .updateIsAuthComplete(let emailToken):
            self.accountInfo.authToken = emailToken
            state.isAuthComplete = (emailToken != nil)
            state.errorMessage = nil
            state.isRequested = false
            self.expireDate = nil
        case .updateFindIds(let findIds):
            state.findIds = findIds
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        case .stateReset:
            self.isFirst = true
            self.expireDate = nil
            // 이메일 인증상태 유지
            let isValid = state.isValidEmail
            state = self.initialState
            state.isValidEmail = isValid
        }
        return state
    }
    
    func reactorForPassword(email: String) -> FindAccountPasswordViewReactor {
        self.accountInfo.email = email
        return FindAccountPasswordViewReactor(
            provider: self.provider,
            entryType: .findAccount,
            accountInfo: self.accountInfo
        )
    }
    
    func reactorForIdResult(ids: [String]) -> FindAccountIdResultViewReactor {
        return FindAccountIdResultViewReactor(provider: self.provider, ids: ids)
    }
}
