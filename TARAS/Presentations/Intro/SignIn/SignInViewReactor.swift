//
//  SignInViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import FirebaseMessaging
import ReactorKit
import RxSwift

class SignInViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case checkValidation(id: String, password: String)
        case signIn(id: String, password: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsSignIn(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isSignIn: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    let initialState: State = .init(
        isValid: false,
        isSignIn: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .checkValidation(id, password):
            let isValid = id.count > 0 && password.count > 0
            return .just(.updateIsValid(isValid))
        case let .signIn(id, password):
            
            // 로그인 시도 전, 아이디와 비밀번호 포맷 검사
            guard InputPolicy.id.match(id) else {
                return .just(.updateError(.common(.invalidInputFormat(.id))))
            }
            guard InputPolicy.password.match(password) else {
                return .just(.updateError(.common(.invalidInputFormat(.password))))
            }
            guard let clientInfo = self.provider.userManager.userTB.clientInfo else {
                return .empty()
            }
            
//            let input = LoginInput(
//                clientInfo: clientInfo,
//                clientType: "ios",
//                password: password,
//                userId: id
//            )
//
//            return .concat([
//                .just(.updateIsProcessing(true)),
//
//                self.provider.networkManager.perform(SignInMutation(input: input))
//                    .map { $0.loginMutation }
//                    .flatMapLatest { [weak self] data -> Observable<Mutation> in
//                        guard let self = self else { return .empty() }
//
//                        // 🟢 로그인 성공
//                        if let payload = data.asLoginPayload
//                        {
//                            // 1. 토큰 업데이트
//                            self.provider.userManager.updateTokens(
//                                access: payload.accessToken,
//                                refresh: payload.refreshToken
//                            )
//
//                            // 2. 웹소켓 정보 업데이트
//                            self.provider.networkManager.updateWebSocketTransportConnectingPayload()
//
//                            return .concat([
//                                // 3. fcm 토큰 업로드
//                                self.uploadFcmToken(),
//                                // 4. 유저 정보 불러오기
//                                self.loadUserInfo()
//                            ])
//                        }
//                        // ❌ 로그인 실패
//                        else if let error = data.asLoginError
//                        {
//                            let error: TRSError? = {
//                                switch error.errorCode {
//                                case .invalidPassword:
//                                    return .account(.idPasswordNotMatch)
//                                case .invalidUserId:
//                                    return .account(.idNotExist)
//                                default:
//                                    return .etc(error.errorCode.rawValue)
//                                }
//                            }()
//                            return .just(.updateError(error))
//                        }
//                        return .empty()
//                    }
//                    .catchErrorJustReturn(.updateError(.common(.networkNotConnect))),
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
        case .updateIsSignIn(let isSignIn):
            state.isSignIn = isSignIn
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
//    func reactorForSignUp() -> SignUpIdViewReactor {
//        return SignUpIdViewReactor(provider: self.provider)
//    }

//    func reactorForWorkspaceList() -> WorkspaceListViewReactor {
//        return WorkspaceListViewReactor(provider: self.provider, isFrom: .signIn)
//    }

    func reactorForForgotAccount() -> SignInViewReactor {
        return SignInViewReactor(provider: self.provider)
    }

//    func reactorForFindAccountId() -> FindAccountEmailViewReactor {
//        return FindAccountEmailViewReactor(provider: self.provider, type: .id)
//    }
//
//    func reactorForFindPassword() -> FindAccountIdViewReactor {
//        return FindAccountIdViewReactor(provider: self.provider)
//    }
}

extension SignInViewReactor {
    
//    func loadUserInfo() -> Observable<Mutation> {
//        return self.provider.networkManager.fetch(MyUserInfoQuery())
//            .map { $0.myUserInfo }
//            .flatMapLatest { [weak self] data -> Observable<Mutation> in
//                guard let self = self,
//                      let user = data.asUser?.fragments.userFragment else {
//                    return .empty()
//                }
//                self.provider.userManager.updateUserInfo(user)
//                return .just(.updateIsSignIn(true))
//            }
//            .catchErrorJustReturn(.updateError(.common(.networkNotConnect)))
//    }
//
//    func uploadFcmToken() -> Observable<Mutation> {
//        guard let token = Messaging.messaging().fcmToken, let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString else {
//            return .empty()
//        }
//
//        let input = UpdateFcmRegistrationIdInput(
//            clientType: "ios",
//            deviceUniqueKey: deviceUniqueKey,
//            registrationId: token
//        )
//
//        Log.info("\(input)")
//
//
//
//        return self.provider.networkManager
//            .perform(UpdateFcmTokenMutation(input: input))
//            .map { $0.updateFcmRegistrationIdMutation }
//            .flatMapLatest { result -> Observable<Mutation> in
//                if let payload = result.asUpdateFcmRegistrationIdPayload {
//                    if payload.result.isTrue {
//                        Log.complete("updated FCM token to server")
//                    }else{
//                        Log.complete("Failed FCM token updated to server")
//                    }
//                }else if let error = result.asUpdateFcmRegistrationIdError {
//                    Log.err("Failed to update FCM token to server: \(error.errorCode)")
//                }
//                return .empty()
//            }
//            .catchErrorJustReturn(.updateError(.common(.networkNotConnect)))
//    }
}
